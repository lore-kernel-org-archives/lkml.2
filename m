Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1AaTv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:51:57 -0500
Received: from xenotime.net ([72.52.115.56]:35785 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753178Ab1AaTv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:51:56 -0500
Date: Mon, 31 Jan 2011 11:51:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Brian D. McGrew" <brian@visionpro.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Ioctl
Message-Id: <20110131115152.b327044f.rdunlap@xenotime.net>
In-Reply-To: <C96C4FE1.46AA1%brian@visionpro.com>
References: <C96C4FE1.46AA1%brian@visionpro.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 11:39:13 -0800 Brian D. McGrew wrote:

> Hello,
> 
> I'm very new at working with the kernel and device drivers and I'm trying to
> bring ours drivers up from a 2.6.16 kernel to 2.6.37.  I'm noticing that
> ioctl() doesn't seem to be raound anymore, or at least I can't find it.
> 
> There is tons of stuff in my code that I don't yet understand which requires
> the ioctl function.  What is the best way for me to either get the ioctl
> working in 2.6.37, or the quickest way to work around it???

ioctl() is still around.

fs/ioctl.c:
SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
{

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
