Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1DPQj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:39:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42719 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1DPQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=xtVXj+Wp4Qx1P4yyoGvZCFCew3e1crwzJOKky+Mm5UX5Z+3rAJ4sXqlStNRmhT2ceP
         YPk7RzY4xyDMQpzXjeyYg8y1IcVl/Erk0IijvhJj/nsbubrYiayaZ6itk0u40rQvgDO0
         0pI8MMVVm4mZ3DONV4sTn3FkiFclrGKE2nWqE=
MIME-Version: 1.0
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Sat, 16 Apr 2011 18:38:59 +0200
Message-ID: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
Subject: [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3
 (works in 2.6.38.3)
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am having problems pairing bluetooth devices in 2.6.39. Scanning
works fine (hcitool scan), but when I try to pair a device using
"bluez-simple-agent hci0 $MAC", I receive the following error message:
"Creating device failed: org.bluez.Error.Failed: Input/output error"

The same command reliably works on a 2.6.38.3 kernel with pretty much
the same config.

According to lsusb, I have a Broadcom Bluetooth Controller with ID
0a5c:217f. I don't see anything related in either of the dmesgs.
My lspci output is here: http://sukzessiv.net/x120e/
Userspace is an up-to-date Ubuntu 11.04 beta (with bluez 4.91).

If there are any debugging steps that I could do or patches to try or
revert, let me know. Unfortunately I can't do a proper bisect since
the machine is a netbook type.

cheers,
gohai
