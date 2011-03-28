Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1C1T7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:59:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab1C1T7U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 12:58:31 -0700
Message-ID: <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com>
Subject: Re: [GIT pull] irq cleanups for .39
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:50 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Thomas Gleixner (1):
>      vlynq: Convert irq functions

Can we please not use those irritating "LKML-Reference" lines in the commits?

The things are a pain. They don't work for google, they don't work for
sh*t. They end up being effectively just random noise.

Either don't do them at all, or put a real pointer to a lkml archive
that is actually *useful* - even if people might worry that it isn't
going to be around forever. Eg something like

  http://lkml.org/lkml/2011/3/28/439

or similar.

Who has _ever_ found a use for those email ID's? I don't know who
started doing this, but please stop it.

                              Linus
