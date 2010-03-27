Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0C0Bte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:49:34 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:53567 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0C0Btd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ohcUERHwaKfV6ZHHbwvxXphFca11bqB61ZTcwUIB8pxaxk7GzqvXYSX50IL6bhudAD
         MQYArZPg21UNHNRLartdFa/KgbU4DO872ZYdwfLDkxAQjP95nrSQrIn85u4wJpiJZFyH
         7o82SizAJTMf4jmeXI2FF+UxtR40kObnt7ViQ=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging: comedi frivers patches
Date: Sat, 27 Mar 2010 09:48:34 +0800
Message-Id: <1269654523-2682-1-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is me stepping up after watching a video on Greg KH's presentation on kernel patching in FOSDEM 2010.

All patches here correct brace coding style issue.

There are no dependency between the patches, except patch 8 and patch 9, which should be apply in correct order.

[PATCH 1/9] Staging: comedi: amplc_pci224: fixed multiple brace coding style issue
[PATCH 2/9] Staging: comedi: amplc_pci230: fix brace coding style issue
[PATCH 3/9] Staging: comedi: adl_pci9111: fixed multiple brace coding style issue
[PATCH 4/9] Staging: comedi: adl_pci9118: fixed multiple brace coding style issue
[PATCH 5/9] Staging: comedi: adv_pci1710: fixed multiple brace coding style issue
[PATCH 6/9] Staging: comedi: adv_pci_dio: fixed multiple brace coding style issue
[PATCH 7/9] Staging: comedi: cb_das16_cs: fixed multiple brace coding style issue
[PATCH 8/9] Staging: comedi: cb_pcidas64: fixed multiple brace coding style issue
[PATCH 9/9] Staging: comedi: cb_pcidas64: fixed a coding style missed in the previosu patch

Cheers

-Jason
