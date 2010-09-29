Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0I2CJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 22:09:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62337 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab0I2CJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 22:09:13 -0400
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@gmail.com>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: David Henningsson <david.henningsson@canonical.com>
Subject: Band-aid solution for Dell Latitude E6410/E6510 microphone
Date: Wed, 29 Sep 2010 04:09:00 +0200
Message-Id: <1285726141-26448-1-git-send-email-flameeyes@gmail.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm sending out a patch that I didn't write (and thus most likely require
David's Signed-Off), but which I think might be a good idea to at least
have accessible to search.

As David already pointed out to me, the proper fix for the issue is
Takashi's commit 75e0eb24ee3ec3549c2e53707dcc87e5f7a2c791, but that hasn't
made it into .36 RCs and thus seem unlikely to come to users anytime soon.

David's patch is a "band aid" solution; it solves most of the problem by
adding one more special case to the sigmatel patches; on the other hand it
makes the internal microphone to work fine on my laptop, which is a good
thing, right?

Anyway, if this can be considered for .36 or for some stable branch (*looks
toward Greg hoping for pity*), it would probably make me (and other owners
of such laptops) probably very happy. Especially given that we have enough
trouble with a non-working SDHCI and a not-yet-supported Alps
touchpad/trackpoint combination.

Thanks in advance, whatever the outcome,

-- 
Diego Elio Pettenò
