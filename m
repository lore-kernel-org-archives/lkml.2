Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1LSOto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:49:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:48779 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1LSOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:49:42 -0500
Date: Mon, 19 Dec 2011 15:49:40 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: convert to generic irq_domain
Message-ID: <20111219144940.GI20801@linutronix.de>
References: <1324099129-28832-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1324099129-28832-1-git-send-email-robherring2@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rob Herring | 2011-12-16 23:18:49 [-0600]:

>This is needed to avoid struct collisions with the generic irq_domain
>support being added to kernel/irq/generic-chip.c.
>
>Boot tested, but not on a DT enabled platform.

I had a patch in my tree for this and it did not work. One bug was fixed
by eef24a ("irq: Fix check for already initialized irq_domain in
irq_domain_add"). Something else come up after that. I will grab a board
test it later and let you know :)

Sebastian
