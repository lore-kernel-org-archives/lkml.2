Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0CQTyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:54:47 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:56718 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0CQTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:54:46 -0400
Date: Wed, 17 Mar 2010 14:54:06 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
In-Reply-To: <1268846083.4773.64.camel@useless.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.00.1003171453530.4231@router.home>
References: <4B990496.4020002@kernel.org>  <alpine.DEB.2.00.1003161107070.2311@router.home>  <4BA00CE4.1090108@kernel.org>  <alpine.DEB.2.00.1003171134070.27268@router.home> <1268846083.4773.64.camel@useless.americas.hpqcorp.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010, Lee Schermerhorn wrote:

> s/from slab.h/from topology.h/ is the update Christoph is indicating.
> Right, Christoph?

Right.

