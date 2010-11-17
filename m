Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab0KQNlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:41:08 -0500
Received: from bof-2.saar.de ([192.109.53.146]:46123 "EHLO oknodo.bof.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab0KQNlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:41:06 -0500
Subject: 2.6.37-rc2 vs. 2.6.36 laptop backlight changes?
From: Patrick Schaaf <netdev@bof.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 14:41:02 +0100
Message-ID: <1290001262.5727.2.camel@lat1>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Spam_score: -4.4
X-Spam_score_int: -43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

were there any changes between 2.6.36 and 2.6.37-rc2 that would affect
laptop display backlight control?

I have a Dell Latitude D630 laptop, with Intel on-board graphics

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 0c)

used docked in dual-monitor setup. System is openSUSE 11.3, X.Org X
Server 1.8.0

I notice that after logging in, under 2.6.37-rc2, the backlight of the
laptop display is dimmed down. Using the brightness keys can turn it
back up again. Logging out and logging in again, dims it again.

I do not notice this with 2.6.36.

Anything to try to resolve or diagnose this?

best regards
  Patrick



