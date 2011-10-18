Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab1JRMax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:30:53 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:45658 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab1JRMau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:30:50 -0400
Subject: Re: [PATCH 12/21 v2] m68k: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E9D6C05.9040106@snapgear.com>
References: <1318925407.6414.22.camel@x61.thuisdomein>
	 <4E9D6C05.9040106@snapgear.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 14:30:43 +0200
Message-ID: <1318941043.6414.35.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 22:07 +1000, Greg Ungerer wrote:
> > - dropped SOM5282EM too (discovered this while doing this second
> >    version, my scripts aren't smart enough too catch it)
> 
> Hmm. I don't want to lose the SOM5282EM config option. Although it
> isn't used inside the code it does let the configurer know that this
> specific board is supported.

Isn't there another way? You're also adding a configuration option. This
means your configurer has to make a decision whether or not to enable
support for that board while this decision actually has no effect.
Apparently that support comes for free (I'm guessing once M528x support
is enabled, I haven't checked that). Wouldn't a comment do? Or adding a
line to some help text? 

In the mean time I suppose you're willing to fix this part of my patch
yourself (ie, I don't have to redo this again).


Paul Bolle

