Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2BGL25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:28:57 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:57453 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab2BGL24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:28:56 -0500
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH 0/2] powerpc: Add support for GE IMP3A
Date: Tue,  7 Feb 2012 11:28:39 +0000
Message-Id: <1328614121-17803-1-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for the GE IMP3A. This board (based on a Freescale
P2020) uses some support for FPGA logic common with the PPC9A and other 86xx
based boards, so this support has been moved out of the 86xx directory. A
config option (GE_FPGA) has been added to reduce churn on dependant drivers
(such as the watchdog timer) when further boards are added.
