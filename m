Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1JDCz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 22:55:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45934 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1JDCz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 22:55:56 -0400
MIME-Version: 1.0
From: Ganesh Karuppur Rajagopalan <ganesh.kr356@gmail.com>
Date: Mon, 3 Oct 2011 22:55:16 -0400
Message-ID: <CAFXDVL8EhVUo9jom_DGEmbSzjA5bUf0iYzGyh-K3AeytL-=VSw@mail.gmail.com>
Subject: Queuing multiple task_struct structures?
To: linux-kernel@vger.kernel.org
Cc: Pallav Bose <pallavbose@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I would like to queue up multiple struct task_structs in my block
device driver. Here, each task_struct would correspond to a userlevel
thread which uses the ioctl() system call to send a userspace buffer
to my block device driver. Once I queue up multiple task_structs, I
would like to keep them on the queue until a particular condition is
met (i.e., the buffer has been written down to the disk).

So, my question is, how do I queue up multiple task_structs, put them
to sleep, and then wake a subset of the queued task_structs when some
condition is met?

Thanks and Regards
Ganesh
