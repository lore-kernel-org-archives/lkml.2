Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2JMPyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 11:54:23 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53583 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab2JMPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 11:54:21 -0400
MIME-Version: 1.0
Date: Sat, 13 Oct 2012 21:24:20 +0530
Message-ID: <CAMjzKwXZLGX7EM7dVOHWcN-8Ay40bbhiR4v5M352Xd2g2uHY1g@mail.gmail.com>
Subject: [Perf] Adding timeout option
From: abhishek agarwal <abhigem.126@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks..

I was thinking that why cant we have a timeout option in perf stat
command.  The timeout feature will help us to profile a process for a
stipulated time (preferably in millisecs) and make perf stat return
after that time.

Eg:

perf stat --timeout=10 sleep 100

This will make perf return and report stats after 10 ms...

Hope anyone can shed some more light on the idea

Thanks & Regards,
Abhishek Agarwal
