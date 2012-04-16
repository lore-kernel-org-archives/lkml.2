Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2DPVTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:19:17 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:53414 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750869Ab2DPVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:19:16 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] snd-ice1712: Add Philips PSC724 Ultimate Edge
Date: Mon, 16 Apr 2012 23:18:34 +0200
Message-Id: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
this is first attempt to add Philips PSC724 Ultimate Edge sound card
support to snd-ice1712 driver. Unlike other snd-ice1712 subdrivers, the codec
code is splitted into separate modules and thus reusable.

Working: all analog outputs (front, rear, center+lfe, headphone) and inputs
(front mic, rear mic, line, cd, aux), mixer, headphone jack detection

Currently untested: SPDIF, real multichannel sounds, power management

Buggy: switching AGC mode in mixer causes alsamixer to crash - looks like
it does not like notifications about control activating/deactivating


