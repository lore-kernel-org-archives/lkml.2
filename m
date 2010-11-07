Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab0KGEv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 00:51:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54643 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0KGEvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 00:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nth02Xoa4VPsrCXupv3Ufa83XyVDJte356iaiK/efVFQdVJK1+fDf+tfDylJ6jozua
         vcI3dbs/MpaIsIQp1nfMQgk60yTKgqsWG1lVfS6LthBM2dtd9UqsyezsLG2Z4B4S3rCd
         2ijf59XERZ0lLVmkiKMZMcilzLCueGxgyE4UE=
Message-ID: <4CD63067.8010506@gmail.com>
Date: Sat, 06 Nov 2010 21:51:51 -0700
From: JD <jd1008@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Question/help re: themake scripts in 2.6.36
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have compiled 2.6.36 (i686) without any problems.
Since then, I have decided to change a couple of
config variables (using xconfig).
When done, running make all
causes the make scripts to stop compilation after building
a few objects, and spawn a shell.
Since I have no idea what to do in that shell, I exit
that shell, and the compilaton continues.
This takes place 3 times before compilation is complete.

Now, when I type make modules_install install,
only modules_install is done. /boot does not get
populated and /boot/grub/grub.conf is unchanged.

The currently installed and running 2.6.36-1
went through a similar scenario during build,
but at least install did work.
Now the install does not work.
Befor the present build attempt,
I had edited the Makefile to change the EXTRAVERSION to -2
in order not to clobber the installed  2.6.36-1

Could someone tell me what to do to force the install in /boot?
/lib/modules does have 2.6.36-2.fc13.i686 fully populated.

Thanx,

JD
