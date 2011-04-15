Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1DOWET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:04:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53419 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab1DOWES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:04:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QztBlK7MRs11B5V/pMHb+E5AqlE5BMwryGkkiPHd0TEKDhogWjVkFqzkhL3Jn9ci6H
         x0mf3fLcox0xsYWsaLtVIjq+FKd1fDiurvcZ08i8ngiVzFyEo588iboOg8LufqLNhr4X
         BoH5ViPgCGHorh1fpHjrsdlm01Q1vVumnj1uM=
Message-ID: <4DA8C0DD.8090003@lwfinger.net>
Date: Fri, 15 Apr 2011 17:04:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Strange build error with new driver on 2.6.39-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a new driver on kernel 2.6.39-rc3 when using a 32-bit system, I 
get the following error:

   MODPOST 511 modules
FATAL: drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se: sizeof(struct 
usb_device_id)=20 is not a modulo of the size of section __mod_usb_device_table=168.
Fix definition of struct usb_device_id in mod_devicetable.h

This error is strange in that this device is PCI based and contains no mention 
of usb_device_id. There is a USB-based driver in the rtlwifi tree, but there is 
also another PCI driver and it does not get this error.

Thanks,

Larry
