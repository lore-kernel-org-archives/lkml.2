Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab1LWRIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:08:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57666 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1LWRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111223145014.4bb74f30@pyx>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
 <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
 <20211.28256.111279.27933@quad.stoffel.home> <20111223145014.4bb74f30@pyx>
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Fri, 23 Dec 2011 22:37:32 +0530
Message-ID: <CAOh0hwNt7bDf5zJy086U=QcMa_5HCMv_KOKmeGnisb8hF3Eujw@mail.gmail.com>
Subject: Re: Intercepting system calls
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: John Stoffel <john@stoffel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

On Fri, Dec 23, 2011 at 8:20 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Write a FUSE module to mount the filesystem through, inside your FUSE
>> module you can intercept the unlink/truncate/write calls and decide
>> what you want to have happen.
>
> Using fanotify and/or a custom security module (or selinux rules) might
> well also be a cleaner way to do it, depending what is actually intended.
>
> Trying to do stuff like archive 'old versions' isn't just about unlink
> however because many programs update the inplace file rather than
> unlink/replace.
I will see what SELinux offers but as far as I know I would need a
kernel recompile/ reinstall for that which most of the users would
avoid. I would still try doing these if I don't find any other way,
but still kprobes seemed a better way but ubuntu kernel does not
enable them.


-- 
Thanks and Regards ,
Gaurav
