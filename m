Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab1EMRIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:08:11 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:23508 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757619Ab1EMRIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:08:09 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Uxdep_cVM1m5MvwX4J49UgFUhSpRdirIPkTtYrd3KyDfYdE
 EhUqvpWfxSR1fWXKUf9BIZvAJM5zYAZt8V_hYETOXIF5WTLo0vDEDEioREkz
 Ew2fMzTLgO.i8Z8KrhfWaa0Xz9bG.edVrU5MjETnUXsnvbiLFjkD5FjSFvgZ
 KF_cRfTTP6s5W1Ik8.TGCgd9x0.IINQaO4hsNKryNqkJjIKsdPUor9iR_6BD
 vrnOh6md8FCCeRG_UsFnTbPB.5SjBhrbunz7cv3G64pAReBKDag3kaXvEiWx
 2mzURm3FTttkYhCSYbl3H2H2z08.nXRaMcKCsXpzXHMiSC.b6
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 13 May 2011 12:08:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>, x86@kernel.org,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: Possible sandybridge livelock issue
In-Reply-To: <m262pezhfe.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1105131207020.24193@router.home>
References: <1305303156.2611.51.camel@mulgrave.site> <m262pezhfe.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Andi Kleen wrote:

> Turbo mode just makes the CPU faster, but it should not change
> the scheduler decisions.

I also have similar issues with Sandybridge on Ubuntu 11.04 and kernels
2.6.38 as well as 2.6.39 (standard ubuntu kernel configs).
