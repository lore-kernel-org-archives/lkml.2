Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2H1Lr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:47:56 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36790 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2H1Lry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:47:54 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com
Subject: [PATCH 0/6] some small cleanups for palmas and DT support
Date: Tue, 28 Aug 2012 13:47:34 +0200
Message-Id: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does a couple of small improvements to the palmas mfd and
regulator drivers. It does a little re-organisation of the header file
to better implement DT in regulator driver and then add DT handling.

Graeme

