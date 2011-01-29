Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1A2IPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:15:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40005 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1A2IPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:15:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Hwt8I1XU9FrbRLfPtXYHwH/m/jNTCro6CXZvAv01dSyD/z0ErkPmFsyqU1+Tu3LbSo
         TQ/1QHvDU5veiJZrb8Meneu1zTFFQRKSnd/40D+PkaoFytkUAEEOI4eNFiA/jhHR8n4t
         Pau5RHeDRI+huHa8vdUpAeUEPH3uueP/X73kk=
MIME-Version: 1.0
Date: Sat, 29 Jan 2011 09:15:11 +0100
Message-ID: <AANLkTinytMpW8-7eEDg1O+vUP=C6-MHc8H8yssRbbxUc@mail.gmail.com>
Subject: USB HID plug and play, hardware developer frustration
From: Robin Theunis <robint91@gmail.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devs,

Currently I am design a USB product, and in that process I also look
if almost every OS supports my device.
The device is just only a HID digitizer or touch tablet thingy. It
reports it self also as HID device. This is to have it
work PLUG and PLAY. But I gotten a cold shower when trying this on my
linux pcs. It doesn't work!
I did some investigation and found that the linux (kernel) only
support mouses and keyboard, all the other usage pages
that are included in the USB HID specs aren't implemented.
http://www.usb.org/developers/devclass_docs/Hut1_11.pdf

Is there a reason why they aren't implemented? especially the
digitizer thingies because of all the new tablets? Is it difficult
to make a driver to support my device? I have seen that there are a
lot of wacom drivers, I think doing all the same thing.

Thanks a lot,

Robin Theunis
