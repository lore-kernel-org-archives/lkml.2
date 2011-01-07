Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1AGQab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:30:31 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41419 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab1AGQaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:30:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=kKa4uF8+afl/OlmXseXiSfgB3W+eKAPSG5IpNptZjo6q/g4hLZ5x1JNXMdc1YDkr+L
         GVbf2wOAkthYARunleMgnvBmcTDHKuSbyJXpBtGrJTLqEu7ibAMoy/XkMEm8PnYYFFqM
         j4Ui13lMVrQ5dkhk+5LD/zNtXKjBYriQEbEVo=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>, anarsoul@gmail.com
Subject: [RFC PATCH 0/2] LEDs: power_supply: Add ability to blink via simple trigger
Date: Fri,  7 Jan 2011 18:28:15 +0200
Message-Id: <1294417697-4692-1-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LEDs blinking API is now available, so it's possible to add ability to blink
via simple trigger and add blinking support to power supply LEDs.
It can be usefull if there's only one LED available, but you want to indicate
if battery is charging or fully charged.

Anton, if it's possible, I'd like these patches to be merged via your battery-2.6
tree, because cross-tree dependencies is evil.

