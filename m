Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0FYNjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:39:53 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:59455 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0FYNjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:39:51 -0400
X-SENDER-IP: [217.174.79.66]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO5IJEzZrk9C/2dsb2JhbACfQHHBTA2FFASEAYYi
X-IronPort-AV: E=Sophos;i="4.53,481,1272837600"; 
   d="scan'208";a="537856017"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Ping Cheng <pingc@wacom.com>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/2] [RESEND] MT slots
Date: Fri, 25 Jun 2010 15:15:20 +0200
Message-Id: <1277471722-2963-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 25 Jun 2010 13:15:32.0598 (UTC) FILETIME=[7D90B160:01CB1468]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Please find enclosed a resend of the MT slot patches, targetting
2.6.36. The MT slots are implemented in the mtdev library, so the
protocol is getting a fair amount of testing. Regarding MT event codes
that require special initial values, it is assumed that the driver
will initalize the mt slots properly.

Thanks,
Henrik

Henrik Rydberg (2):
  input: mt: Introduce MT event slots (rev 5b)
  input: mt: Document the MT event slot protocol (rev5b)

 Documentation/input/multi-touch-protocol.txt |  217 ++++++++++++++++++--------
 drivers/input/input.c                        |  105 ++++++++++---
 include/linux/input.h                        |   44 +++++
 3 files changed, 271 insertions(+), 95 deletions(-)

