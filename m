Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1CUMoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:44:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33046 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1CUMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=PoyxwUynBw7YyJg4NXvNvkj9tXPr775+PK6LfVhdyPEbmSTzvz39Fnc/et58SWQHtT
         MSHd7vbcHamV2U2KHQfTRrps7hagP98H/fR8C19PrcAfKrzzDjuA09hRzC60by/E69GL
         K/E3huDGB27FOhYVzvU/UWFP7nvt2DVB3Fnik=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 0/2] rtc: sc3: Fix compilation errors.
Date: Mon, 21 Mar 2011 13:43:54 +0100
Message-Id: <1300711436-32296-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mini2440_defconfig compilation (possibly also others) are broken
with change : https://lkml.org/lkml/2011/3/15/354

Function s3c_rtc_setpie was remove but not all references
was removed too.

Marek Belisko (2):
  rtc: s3c: Fix compilation error in s3c_rtc_release.
  rtc: s3c: Fix compilation error in s3c_rtc_remove.

 drivers/rtc/rtc-s3c.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

