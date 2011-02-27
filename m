Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1B0R0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 12:26:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56220 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1B0R0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 12:26:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=xe3O6VTHE6M1qG0dWy+gLtW0PiYfM3Z7RpIGFKQWe37na8QPlyrc/qqjpwtYCsLHVa
         4MDbk/9E6DV469UA3xviE9c/eSP8sigRqJQgrQ8BhlX9Z5T+4+6gcu0NkMPynGd7IX9B
         5i43LsTtlHeab7UgH8EtHkijs6aI8Jr5Z2yqw=
MIME-Version: 1.0
Date: Sun, 27 Feb 2011 12:26:43 -0500
X-Google-Sender-Auth: ybk-qYXCCwawFeQ947Q7UwkP25o
Message-ID: <AANLkTim8tnk=0_uHxx1=EKrmuhsO7iMGBb_jiJeyjCgy@mail.gmail.com>
Subject: help with unknown symbols when trying to load kernel module
From: George Nychis <gnychis@cmu.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Long story short, I am trying to rebuild a kernel module for my
android phone.  Unfortunately, Motorola did not post the kernel
configuration they used
(https://opensource.motorola.com/sf/sfmain/do/viewProject/projects.droid
- I am running 2.2.1).  They also did not configure the kernel to dump
it at /proc/config.gz. I have the exact source code used to build both
the kernel, and the wireless kernel module used.  But again, I do not
have the exact kernel configuration.  Therefore, I do not want to
replace the kernel on the phone (in fear of misconfiguration causing
boot errors), I simply want to rebuild the wireless module and get it
to work with the kernel already on the phone.

I've tried getting help from the android community, however their
kernel mailing list only gets about 3 messages a day and posts are
moderated and lag behind something like 4 days.  So, I'm hoping for a
little bit of help here on the linux end of things from the linux
community.

I've ballparked the configuration using an older configuration file
posted on another forum, and was able to successfully build my own
kernel (albeit I do not use it), and then also build the wireless
module successfully.

When I try to load the module on the phone, I get a pretty long list
of undefined symbols:
http://pastebin.com/re5mRj4E

I decided to start by focusing on one of these errors,
'register_netdev' and used 'nm' on my kernel module and found that it
is undefined:
00073b60 T regReadLastDbgState
         U register_netdev
000345ec T regulatoryDomain_SetDefaults

Here is the entire nm output:
http://pastebin.com/8kTDKF87

I'm a little confused as to what this means.  Does this mean that the
stock kernel on the phone does not have this symbol?  It seems odd
since I believe the wireless module requires it. Or does it mean
something else?

Thanks for any help.  I'm also not registered on the mailing list, so
if you could CC me on any responses I would sincerely appreciate it.

- George
