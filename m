Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1BWIml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:42:41 -0500
Received: from ist.d-labs.de ([213.239.218.44]:46118 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab1BWImk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:42:40 -0500
Date: Wed, 23 Feb 2011 09:42:19 +0100
From: Florian Mickler <florian@mickler.org>
To: Dave Airlie <airlied@gmail.com>
Cc: akpm@linux-foundation.org, airlied@linux.ie, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64-agp: fix crash at second module load
Message-ID: <20110223094219.0babbd98@schatten.dmk.lab>
In-Reply-To: <AANLkTinyEo62CurDuWnt-Mq0bbQyS+-Fe06_=izNbzGA@mail.gmail.com>
References: <1297117771-12392-1-git-send-email-florian@mickler.org>
	<20110223092619.4dfa7480@schatten.dmk.lab>
	<AANLkTinyEo62CurDuWnt-Mq0bbQyS+-Fe06_=izNbzGA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 18:28:21 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Wed, Feb 23, 2011 at 6:26 PM, Florian Mickler <florian@mickler.org> wrote:
> > Hi Andrew,
> > I sent this to Dave Airlie because that is what MAINTAINERS says, but
> > that is probably the wrong receipient?
> >
> 
> No I just get agp blindspots, esp for the 64-bit ones since they
> interact with x86.
> 
> I'll push it to Linus tomorrow.
> 
> Dave.

Ah ok, I wasn't shure, because there were no commits from you over
there. 

Thanks,
Flo
