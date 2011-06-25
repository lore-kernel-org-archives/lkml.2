Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1FYQOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 12:14:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59211 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1FYQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 12:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hY1qXZA7MqKkxtChkXFAvUFbF5NSdVeo+ygXpyoCeYAV3WpksiUvDALiiEAtmtT7II
         kIaKMMrY6JcWFJ22u3W0L07h5ZClysnX/XJYFSk2SdDCwmNYUZuFP/9BHDbuMhpNxtNU
         ezEdZ/01XtyAt8DhC2tH3P2jJ2Xx4WG3qkWsI=
MIME-Version: 1.0
Date: Sat, 25 Jun 2011 09:14:06 -0700
Message-ID: <BANLkTikhLbGmp7eeWFKwT0z2btV2js-9vw@mail.gmail.com>
Subject: Petalinux Build errors
From: sirish m <x01123581321@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[INFO ] Building image files
[ERROR] FATAL ERROR: Unable to parse input tree
[ERROR] make[4]: ***
[arch/microblaze/boot/Digilent-Digilent-Atlys-MMU-full-13.1.dtb] Error
1
[ERROR] make[3]: *** [arch/microblaze/boot] Error 2
[ERROR] make[2]: ***
[/home/bullhound/petalinux/software/petalinux-dist/linux-2.6.x/arch/microblaze/boot/simpleImage.Digilent-Digilent-Atlys-MMU-full-13.1]
Error 2
[00:09]  make[1]: *** [image] Error 255
[00:09] / make: *** [image] Error 255

Please checkout my build log here
http://www.box.net/shared/3fp4r7ev5hpdgay7h5aa
