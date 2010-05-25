Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0EYLUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:20:33 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:40538 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0EYLUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ITHJ7Cl9FeXh7R14bpXBfZr+ZNi7KYt3OjSrnUE8YAaLfXriOQlzlJpk5g4Epy+1sP
         FsCFsPQpTiWiM1dX7vUWHQrMWfSdRzmhWT8hpNywh8Eg1JVGrmaHmw5fQ3fhfEfDRGQn
         IymtsJADAHy3vxDpm8kZj8bWd8Fz4LMHyHwJw=
MIME-Version: 1.0
Date: Tue, 25 May 2010 16:50:31 +0530
Message-ID: <AANLkTim7d3LpSp23LMOqwPz-Rnp0Idflf5JWUTDyplMU@mail.gmail.com>
Subject: building linux kernel
From: ranjith kumar <ranjithproxy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using fedora11 on my PC. I downloaded the linux kernel souce code.
I copied config file from /boot directory and tried to compile. I am
getting some compilation errors.
So  I configured the kernel, with 'make defconfig', and it is
compiling successfully.
But when I am booting my machine with new kernel, it simply starts and
displays '-' at top of the screen. nothing more.

My question is are fedora and linux kernel are connected or  not? If so how?
I thinks linux kernel runs for a while, when it is booted. But after
that control comes to fedora.

For example, in Fedora we can play chess.Windows are
displayed.......etc ...many graphical things are there.
I don't think that these gaphics, chess game.....are not part of linux kernel.
Am I right?

Also, some time back when I was using fedora10, I configured linux
kernel with /boot/ config file. I successfully compiled and run new
linux kernel.
When I boot with new kernel, it is still going into fedora. But when I
run uname command it is showing new kernel version. But how come I was
able to play chess game? chess game is not part of kernel.


So if you got what I am asking, please tell me how to disconnect
fedora and linux kernel? So when I boot with new kernel only kernel's
things  should be running. not fedora's chess game. How to disconnect
them?

Thanks in advance
