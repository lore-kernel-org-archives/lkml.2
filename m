Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0CTSPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:15:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:10030 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0CTSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RX8zKhZTtUxWQMjC6sEV06SIdfOvmiiC0WD8FfvrUhJ6Isz6Aj2OJzf1dkC2bEf3qI
         C/PcMBVpqDJ4SPrpt8J48nnutXarNaCNLP2D/lg9Sd3wS3VS2NKdEvCBwLh5HemvMU38
         uo0sZ9vJte87UndMZ+9vHOciW9QLzAPbAYWsc=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging: comedi drivers patches
Date: Sun, 21 Mar 2010 02:14:01 +0800
Message-Id: <1269108850-1414-1-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is me stepping up after watching Greg HK's presentation in FOSDEM 2010.

All patches here correct brace coding style issue.

There are no dependancy between the patches, except patch 8 and patch 9, which should be apply in correct order.

[PATCH 1/9] Staging: comedi: amplc_pci224: fixed multiple brace coding style issue
[PATCH 2/9] Staging: comedi: amplc_pci230: fix brace coding style issue
[PATCH 3/9] Staging: comedi: adl_pci9111: fixed multiple brace coding style issue
[PATCH 4/9] Staging: comedi: adl_pci9118: fixed multiple brace coding style issue
[PATCH 5/9] Staging: comedi: adv_pci1710: fixed multiple brace coding style issue
[PATCH 6/9] Staging: comedi: adv_pci_dio: fixed multiple brace coding style issue
[PATCH 7/9] Staging: comedi: cb_das16_cs: fixed multiple brace coding style issue
[PATCH 8/9] Staging: comedi: cb_pcidas64: fixed multiple brace coding style issue
[PATCH 9/9] Staging: comedi: cb_pcidas64: fixed a coding style missed in the previosu patch

Cheers,

-Jason
