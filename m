Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0GGNOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:14:23 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:41212 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0GGNOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:14:22 -0400
Date: Wed, 7 Jul 2010 15:16:22 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
Message-ID: <20100707131622.GU10072@secunet.com>
References: <AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
 <20100702111138.GI10072@secunet.com>
 <AANLkTimEgKGJ5pi7GzOnvP42ivJ4GCKX59LdKK0x4fnx@mail.gmail.com>
 <20100706053612.GQ10072@secunet.com>
 <20100706054406.GR10072@secunet.com>
 <AANLkTil4pbOOVvhIKN1_sI8kNdBFFebMVEGEmqrb45YR@mail.gmail.com>
 <20100706074641.GS10072@secunet.com>
 <AANLkTimYK_4PcVrAniOE3pQjgYNwYNjI6q8p1FMZntEa@mail.gmail.com>
 <20100706132825.GT10072@secunet.com>
 <AANLkTilNz3YWxTaUSE3TBm-Q-ZCUaV72o6jJCh77bRH0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilNz3YWxTaUSE3TBm-Q-ZCUaV72o6jJCh77bRH0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:14:20.0079 (UTC) FILETIME=[4F4C2BF0:01CB1DD6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 08:30:40PM +0400, Dan Kruchinin wrote:
> 
> I modified my patches according to the results of our discussion. So
> I'm waiting for your fixes.
> 

I'll send out a patchset later. The first three patches of the patchset
address the empty padata cpumask handling. I did some rough tests and it
appeared to work. However, I still have no fixed testcase for this. So see
whether this works with your patches and whether it meets your requirements.
