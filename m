Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0CUAGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 20:06:09 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52363 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab0CUAGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 20:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length:to
         :reply-to:content-type:content-transfer-encoding:message-id;
        b=DQcrUaLb6WpK5bJxJsPEjY8ZvLMklaWI+MazvTan0V/BNdVRc6QafJkW5fXTxkK9X7
         NpupSfZPRgpXlUIfTZlZkvnuunWvyQ/CugO6aGVlCbcQnz51AIQufuLwt+MJcN50pprj
         oHhsxMyueVYzKyWkcYu8rE+odTh8gm6L49TGE=
From: Florian Fainelli <florian@openwrt.org>
Date: Sun, 21 Mar 2010 01:06:01 +0100
Subject: [PATCH 0/4 v3] RDC321x southbridge and GPIO support
MIME-Version: 1.0
X-TUID: 3829e1e6ca1b4600
X-Length: 1389
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       akpm@linux-foundation.org, wim@iguana.be
Reply-To: Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003210106.01673.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel, Andrew,

This is the third round of the RDC321x southbridge and GPIO support, this 
version should hopefully address all of your comments.

Thanks!

Florian Fainelli (4):
  MFD: add support for the RDC321x southbridge
  GPIO: add support for RDC321x GPIO controller
  WATCHDOG: convert rdc321x_wdt to use southbridge pci device
  x86: remove rdc321x_defs.h
