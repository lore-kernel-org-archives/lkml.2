Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1HYPeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:34:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1HYPeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:34:15 -0400
Date: Thu, 25 Aug 2011 17:31:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
        Petr Vandrovec <petr@vandrovec.name>
Subject: Re: [PATCH v2 00/43] signal: set_current_blocked() and
	block_sigmask()
Message-ID: <20110825153108.GA4578@redhat.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org> <20110824182411.GA30094@redhat.com> <1314246650.3218.3.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314246650.3218.3.camel@perseus.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Ian Kent wrote:
>
> On Wed, 2011-08-24 at 20:24 +0200, Oleg Nesterov wrote:
> >
> > >  fs/autofs4/waitq.c                 |   13 +++-------
> >
> > I applied the whole series with a few acks we got. Other maintainers
> > do not care, I guess.
>
> I wouldn't say that, I didn't NAK it for autofs4.

I meant, "Hopefully other maintainers do not object".

We need to resubmit this patch, set_current_blocked() is not
exported. Your ack is welcomed ;)

Oleg.

