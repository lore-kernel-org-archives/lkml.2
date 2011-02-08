Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1BHXn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:43:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535Ab1BHXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <201102082223.37975.rjw@sisk.pl>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110208122159.GA8284@elte.hu> <201102082218.28015.rjw@sisk.pl> <201102082223.37975.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Feb 2011 15:43:06 -0800
Message-ID: <AANLkTik6SLe79puQ+k_TQVN-tNs=dz4_nu6EzBNKvXr9@mail.gmail.com>
Subject: Re: [PATCH 5/5] PM: Clean up Kconfig dependencies
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack on patches 2-5 in this series. It's just patch 1/5 that I think is
too ugly/odd to live.

                                Linus
