Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2HUGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:09:57 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37865 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752663Ab2HUGJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:09:53 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Dan Luedtke <mail@danrl.de>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, chaosman@ontika.net, muthur@gmail.com,
        kerolasa@iki.fi, linux-kernel@vger.kernel.org
In-Reply-To: <1345333117-2826-1-git-send-email-mail@danrl.de>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Aug 2012 10:09:42 +0400
Message-ID: <1345529382.2457.39.camel@slavad-ubuntu-11>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.176.67.51 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2012-08-19 at 01:38 +0200, Dan Luedtke wrote:
> This patch introduces the Lanyard Filesystem (LanyFS), a filesystem
> for highly mobile and removable storage devices.
> 

Did you have any performance comparison of your file system with others?
Have you any benchmark results? I think that simplicity can be a
valuable thing but performance is a key factor, especially for business
guys.

I think that maybe compression or/and encryption support can be a
valuable feature for such niche of file system that you declared.
Efficient compression support is very important feature for embedded
solutions. Moreover, using of hardware opportunity in the field of
compression or encryption can keep driver code simple.

By the way, what about fault-tolerance of your file system? I don't dive
deeply in documentation of your file systems. But, I think that for USB
sticks or removable storages it is very common situation of sudden
switch off. So, it is very important for your file system to be a very
tolerant to such use-cases. How can you estimate tolerance of your file
system architecture for failure as normal situation?

Moreover, I think that simplicity and strong tolerance to file system
corruption can be a feature. I mean that if you have simple on-disk
layout then, maybe, it is possible to try working in very corrupted
environment also. For the end user, from my point of view, possibility
to work in the case of file system corruption can be very precious
feature.

I think that also for your file system such feature as easy
recoverability of user information in the case of complete corruption of
file system can be very useful thing for an end user. Such easy
recoverability can be achieved by means of on-disk layout and file
system driver's techniques, I think. So, simplicity and easy
recoverability of user data can be a valuable feature also.

With the best regards,
Vyacheslav Dubeyko.

