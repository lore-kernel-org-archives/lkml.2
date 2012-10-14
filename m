Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2JNTKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:10:16 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:42771 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048Ab2JNTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:10:14 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/5] snd-ice1712: Add Philips PSC724 Ultimate Edge
Date: Sun, 14 Oct 2012 21:09:18 +0200
Message-Id: <1350241763-7248-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
this patch series adds full support for Philips PSC724 Ultimate Edge sound
card to snd-ice1712 driver. Unlike other snd-ice1712 subdrivers, the codec
code is splitted into separate files, reusable by other ice1712 subdrivers.

Working: all analog outputs (front, rear, center+lfe, headphone) and inputs
(front mic, rear mic, line, cd, aux), mixer, headphone jack detection,
suspend/resume

Untested: SPDIF

-- 
Ondrej Zary
