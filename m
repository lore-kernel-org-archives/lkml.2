Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab1D0UzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:55:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47857 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab1D0UzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:55:16 -0400
Subject: Re: [GIT PULL] parisc fixes for 2.6.39-rc5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <BANLkTimPzRuGqjxXqe7tn-C52suTVE9+ig@mail.gmail.com>
References: <1303935518.2583.27.camel@mulgrave.site>
	 <BANLkTimPzRuGqjxXqe7tn-C52suTVE9+ig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 15:55:13 -0500
Message-ID: <1303937713.2583.28.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 22:36 +0200, Geert Uytterhoeven wrote:
> On Wed, Apr 27, 2011 at 22:18, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > These two fixes contain the agreed fix for our slub panic (agreed with
> > the mm folks that we'll define SLUB broken in the !NUMA && DISCONTIGMEM
> > case, which should fix m86k as well) and another buglet that turned up
> > examining the parisc discontigmem code.
> 
> Do we still need to mark SLUB broken?
> On m68k, the issue seems to have been fixed by setting the N_NORMAL_MEMORY flag
> (pull request scheduled after one more linux-next build cycle).
> 
> Or do you plan to unmark it broken once every affected arch sets the
> N_NORMAL_MEMORY flag?

Yes ... simply doing N_NORMAL_MEMORY doesn't fix parisc to not oops.

James


