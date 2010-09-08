Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0IHQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:59:33 -0400
Received: from waste.org ([173.11.57.241]:37750 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0IHQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:59:31 -0400
Subject: Re: 2.6.36-rc2 : slabtop report 10170292 size-32 objects...
From: Matt Mackall <mpm@selenic.com>
To: Paul Rolland <rol@as2917.net>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>
In-Reply-To: <20100901115507.705fe5e4@tux.DEF.witbe.net>
References: <20100901113525.04b356c5@tux.DEF.witbe.net>
	 <AANLkTimnBG1qcLwZoEkr_iDkwE4zygLdjFJHVk9S3+wZ@mail.gmail.com>
	 <20100901115507.705fe5e4@tux.DEF.witbe.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 11:59:27 -0500
Message-ID: <1283965167.2964.17.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 11:55 +0200, Paul Rolland wrote:
> Hi Pekka,
> 
> On Wed, 1 Sep 2010 12:41:59 +0300
> Pekka Enberg <penberg@kernel.org> wrote:
> 
> > On Wed, Sep 1, 2010 at 12:35 PM, Paul Rolland <rol@as2917.net> wrote:
> > > I was surprised to see my machine using so much swap when I couldn't
> > > find where all the memory was gone, and I checked quickly what slabtop
> > > had to say, and found that one :
> > >
> > >  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> > > 10172288 10171996  99%    0.03K  90824      112    363296K size-32
> > >
> > 
> > Might be related to this:
> > 
> > http://kerneltrap.org/mailarchive/linux-kernel/2010/8/25/4611329
>  
> Yes, considering that lspci also confirms my machine has some common points 
> with Matt's one :

For the record, I'm using a conventional 2D window manager so the leak
is somewhere in that path.

-- 
Mathematics is the supreme nostalgia of our time.


