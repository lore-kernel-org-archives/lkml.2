Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2IJFOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:14:47 -0400
Received: from ares07.inai.de ([5.9.24.206]:54463 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab2IJFOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:14:45 -0400
Date: Mon, 10 Sep 2012 07:14:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] brd: RAM block module is called 'brd'
In-Reply-To: <1345561837.4564.24.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.01.1209100711380.22738@frira.zrqbmnf.qr>
References: <1345561837.4564.24.camel@x61.thuisdomein>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2012-08-21 17:10, Paul Bolle wrote:
>
>2) "modinfo rd" doesn't work. Apparently one needs to feed modinfo the
>actual module name and not an alias. Is that by design?

I would say so, because you can call

	modprobe --resolve-alias rd

to figure out the actual module to any given string. If this
modprobe call returns nothing, you know you found the terminal name.
