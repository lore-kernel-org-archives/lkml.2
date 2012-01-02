Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2ABNqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:46:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42050 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2ABNqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:46:07 -0500
MIME-Version: 1.0
Date: Mon, 2 Jan 2012 17:16:05 +0330
Message-ID: <CABQ-LR6UuK+vaBhtGTp_PU9Wy+zwbrxNXgGDUKCFCxUWAk1hcg@mail.gmail.com>
Subject: Be informed of task_struct modification
From: Meisam Mohammadkhani <meisam.mohammadkhani@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I want to make an state diagram from changes in related task_struct of
every processes (for using in my algorithm). For example assume that
below is an state diagram:

   1->3->15->2

it will be interpreted as follow:

    the first field of task_struct of a process had been changed, then
the third field of its task_struct had been changed, then ...

I want to know what is the approaches that I can be informed of
changes in task_struct of each processes? for example firs approach is
that I modify the kernel code, so everywhere which task_struct is
going to modify, I inform myself by for example a signal or anything
else. But this approach costs a lot time and will decrease the
performance. Also it will be a huge modification in kernel code. I
want to know if there is anything that is responsible for modification
of task_struct of processes?
