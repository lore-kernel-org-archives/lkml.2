Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab2B1KWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:22:43 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:33381 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872Ab2B1KWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:22:42 -0500
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH V2 0/2] powerpc: Add support for GE IMP3A
Date: Tue, 28 Feb 2012 10:22:19 +0000
Message-Id: <1330424541-5299-1-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for the GE IMP3A. This board (based on a Freescale
P2020) uses some support for FPGA logic common with the PPC9A and other 86xx
based boards, so this support has been moved out of the 86xx directory. A
config option (GE_FPGA) has been added to reduce churn on dependant drivers
(such as the watchdog timer) when further boards are added.
