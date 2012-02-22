Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2BVQPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:15:38 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:46384 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2BVQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:15:37 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: at91: two additional patches to cleanup series
Date: Wed, 22 Feb 2012 17:15:25 +0100
Message-Id: <1329927327-10613-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <5a6951fcbe28c3093c936d40c4b28f7ae3161d8d.1329903206.git.nicolas.ferre@atmel.com>
References: <5a6951fcbe28c3093c936d40c4b28f7ae3161d8d.1329903206.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I queue up two little paches for this cleanup series. They are dealing with
Makefile.boot file and are more a kind of cosmetic modifications.

Those two will go just after the patch:
"[PATCH v2 18/19] ARM: at91/board-dt: drop default console"
as the patch 19/19 will be dropped in the final draft of this series.

Best regards,

