Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2IRTDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:03:04 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:46973 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753721Ab2IRTDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:03:01 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [RFC PATCH v2 0/5] snd-ice1712: Add Philips PSC724 Ultimate Edge
Date: Tue, 18 Sep 2012 20:58:31 +0200
Message-Id: <1347994716-10251-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hello,
this is second attempt to add Philips PSC724 Ultimate Edge sound card
support to snd-ice1712 driver. Unlike other snd-ice1712 subdrivers, the codec
code is splitted into separate modules and thus reusable by other ice1712
subdrivers.

Working: all analog outputs (front, rear, center+lfe, headphone) and inputs
(front mic, rear mic, line, cd, aux), mixer, headphone jack detection,
suspend/resume

Currently untested: SPDIF

Buggy: switching AGC mode in mixer causes alsamixer to crash - looks like
it does not like notifications about control activating/deactivating
