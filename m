Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1LEIUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:20:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:53902 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1LEIUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:20:49 -0500
Date: Mon, 5 Dec 2011 09:20:47 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Shimrit Malichi <smalichi@codeaurora.org>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org
Subject: [RFC] UASP on target (was: [RFC/PATCH v4 1/3] uas: MS UAS Gadget
 driver - Infrastructure)
Message-ID: <20111205082047.GA2423@linutronix.de>
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:

>This patch implements the infrastructure for the UAS gadget driver.
>The UAS gadget driver registers as a second configuration of the MS
>gadet driver.
hch said to use target framework and you haven't done so. This is what I
have so far. It is not yet complete. What I need to do is:
- wire up command processing (currently here)
- wire up data processing
- check it works => post v1
- wire up command tagging => v2
- remove hard codings and fix whatever people complained about.

Sebastian
