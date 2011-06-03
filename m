Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1FCULK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:11:10 -0400
Received: from mail.perches.com ([173.55.12.10]:2497 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1FCULI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:11:08 -0400
Subject: Re: [PATCH] drivers: video: Remove useless checks
From: Joe Perches <joe@perches.com>
To: Maxin B John <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tim.gardner@canonical.com, airlied@redhat.com, lethal@linux-sh.org,
        james@albanarts.com, error27@gmail.com, randy.dunlap@oracle.com
In-Reply-To: <BANLkTimYNB8CgK=Q8TT0qCZvbEV5JVHuhw@mail.gmail.com>
References: <20110519182702.GA3337@maxin>
	 <BANLkTimYNB8CgK=Q8TT0qCZvbEV5JVHuhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 13:11:06 -0700
Message-ID: <1307131866.14598.49.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 10:29 +0100, Maxin B John wrote:
> ping ...
> On Thu, May 19, 2011 at 7:27 PM, Maxin B John <maxin.john@gmail.com> wrote:
> > Comparing unsigned less than zero will never be true.
> > Removing similar checks from 'fbmem.c' and 'fbcmap.c'.
> > Please let me know your comments.

http://lkml.org/lkml/2004/11/23/171


