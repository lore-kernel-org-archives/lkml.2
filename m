Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1BPV4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:56:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34028 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1BPVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:55:59 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: kernel@pengutronix.de
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] RFC: introduce typechecking to platform_{get,set}_drvdata
Date: Wed, 16 Feb 2011 22:55:49 +0100
Message-Id: <1297893351-2900-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

just found a mis-user of platform_set_drvdata(), so introduce typechecking
to these macro definitions. An alternative would be to make them static inline
functions.

comments welcome,
Marc


