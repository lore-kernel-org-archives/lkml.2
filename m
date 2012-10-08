Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2JHXKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:10:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37645 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035Ab2JHXKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:10:38 -0400
Message-ID: <1349737836.15802.24.camel@joe-AO722>
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
From: Joe Perches <joe@perches.com>
To: "\"Jan H." =?ISO-8859-1?Q?Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>
Cc: Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 16:10:36 -0700
In-Reply-To: <50732F8A.9090109@cs.tu-berlin.de>
References: <5064790E.4000207@cs.tu-berlin.de>
	 <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com>
	 <5065B909.1060907@cs.tu-berlin.de>
	 <CAPXgP12v0aNtUnhKep3QiJwZYAp=NHebHVfS9N35V2EOSmAufg@mail.gmail.com>
	 <CAPXgP13GCsooDtbor9_OvyDCZjPARL_On_cBtEoxTUWnVsBpvw@mail.gmail.com>
	 <50732F8A.9090109@cs.tu-berlin.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 21:54 +0200, "Jan H. Schönherr" wrote:
> Am 08.10.2012 21:24, schrieb Kay Sievers:
> > On Fri, Sep 28, 2012 at 4:56 PM, Kay Sievers <kay@vrfy.org> wrote:
> >> On Fri, Sep 28, 2012 at 4:49 PM, "Jan H. Schönherr"
> >>> Given that I'm able to fix the racing case, would you be in favor of
> >>> this approach, or should we stick to the earlier version?
> >>
> >> I'm open to everything that makes sense. Let's see how it looks and we
> >> can decide when we have something that passes the tests.
[]
> > any updates, did you try something else?
> > Or should we merge the first version for now?
[]
> My current version does mostly well for race-printk()s, now. But
> there's still one issue to resolve and some polishing to do.
> 
> If we can afford to wait a little longer, we might get a nicer
> solution (and avoid a possible mostly-revert later).

I've also got a large refactoring patch series to printk.c
(move and declutter) I was going to submit post rc-1.

No doubt there'll be several conflicts there too.


