Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1FVJwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:52:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:57309 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab1FVJwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:52:10 -0400
Date: Wed, 22 Jun 2011 11:52:05 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 1/2] usb:dummy_hcd: connect/disconnect test
 support
Message-ID: <20110622095205.GA24674@linutronix.de>
References: <1308731945-7601-1-git-send-email-tlinder@codeaurora.org>
 <1308731945-7601-2-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1308731945-7601-2-git-send-email-tlinder@codeaurora.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tatyana Brokhman | 2011-06-22 11:39:00 [+0300]:

>This implementation adds a new proprietary device control requests (to be
>handled by the dummy_hcd) that initiates a connect/disconnect sequence.
>The bRequest value of the new control request is 0x52.
>It is used by the user-space Unit testing application.
>
>Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>

As far as I understand this should be used to test real Hardware. Mind
moving this to composite_setup() so it can be re-used by other ucd as
well? usb_gadget_*nect() should do the pullup() trick.

Sebastian
