Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0CUVDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:03:55 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:33789 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0CUVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oLDGqyWlUggFq4C7PcpPBMg4bVytLnBzKu8uYcSIe21Vu1FLyEaP1h4FM5G2eHZsBB
         bdUvAz451gen3R/UBYHsbV1/F4VJn5iVEq3v4oqtPFH+rtQbh5g0W1Z3NrT5ELARF90s
         aY/yWcddCidZ/d1/+Pu8q/m+SXWmrI5cOeLFE=
MIME-Version: 1.0
Date: Sun, 21 Mar 2010 22:03:51 +0100
Message-ID: <c384c5ea1003211403t494bd794hece06d8b8cfcb54@mail.gmail.com>
Subject: CrystalHD driver safe on big endian systems?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: jarod@wilsonet.com, "Naren (Narendra) Sankar" <nsankar@broadcom.com>,
       "hancockrwd@gmail.com" <hancockrwd@gmail.com>,
       "jarod@redhat.com" <jarod@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "davilla@4pi.com" <davilla@4pi.com>,
       "abraham.manu@gmail.com" <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

has the CrystalHD driver/library been tested on big endian systems?

The (staging GIT tree) driver sources seem to use bitfields in C, is
this safe under different endianess?

I'm currently testing two BCM70012 modules on a big-endian PowerPC
system and it fails changing the clock PLL to 175 MHz. This could be a
pair of defective modules, or the wrong bits being modified.
Unfortunately, I do not have a little endian system with mini-PCIe
available to do a A-B check.

Regards,
-- 
Leon
