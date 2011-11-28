Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1K1TAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:00:18 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35476 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299Ab1K1TAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:00:14 -0500
Subject: Re: [PATCH 10/62] ata: remove the second argument of
 k[un]map_atomic()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Cong Wang <amwang@redhat.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
In-Reply-To: <4ED37541.4040701@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	 <1322371662-26166-11-git-send-email-amwang@redhat.com>
	 <4ED35BFE.6080900@mvista.com> <4ED373C3.4050903@redhat.com>
	 <4ED37541.4040701@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 13:00:12 -0600
Message-ID: <1322506812.5071.37.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 19:49 +0800, Cong Wang wrote:
> 于 2011年11月28日 19:42, Cong Wang 写道:
> > 于 2011年11月28日 18:01, Sergei Shtylyov 写道:
> >> Hello.
> >>
> >> On 27-11-2011 9:26, Cong Wang wrote:
> >>
> >>> Signed-off-by: Cong Wang<amwang@redhat.com>
> >>> ---
> >>> drivers/ata/libata-sff.c | 8 ++++----
> >>> 1 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >> IMO, you should do this in a single patch, not piecemeal to keep the kernel bisectable.
> >>
> >
> > Hi,
> >
> > Please see patch 01/62,
> >
> > https://lkml.org/lkml/2011/11/28/35
> >
> > So even without it, the kernel can still compile, just with some warnings.
> >
> 
> Ah, no, sorry that I replied too quickly. We have to have at least 01/62
> to compile.
> 
> Actually I did make the patches as a whole, but Andrew Morton prefers to
> split them, so I make V2 of them.

I'd vote for as a whole as well, but if there's some legitimate reason
why not, then take them through Jiri's trivial tree; it's pretty trivial
anyway and at least going that way would keep them bisectable.

James


