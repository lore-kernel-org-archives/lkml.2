Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0FCNZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:25:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44662 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0FCNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kRZf1I+SrcOj2xLoV1nBu8uFR6Z8SeiAi7bLKx6WS+yQgi0CcUFzxFEfxAj9qUAp8Q
         Nwn+MII3qqguCuthU5x7mSBMQzyK8q5J+Stjbd0O4qAMOua+FQEEgBmfpLkbQlYYI0K8
         xtqE4LkcMn9H23yxqirQaxAsVpbjgjQTB5fNw=
Date: Thu, 3 Jun 2010 06:25:54 -0700
From: mark gross <640e9920@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: markgross@thegnar.org,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>, 640e9920@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603132554.GB15595@gvim.org>
Reply-To: markgross@thegnar.org
References: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
 <201005312338.55109.rjw@sisk.pl>
 <20100531232617.GF31155@gvim.org>
 <20100601090737.4bc243d9@schatten.dmk.lab>
 <20100601140519.GC1281@gvim.org>
 <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
 <20100602133910.GA9106@gvim.org>
 <AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
 <20100603031842.GB11311@gvim.org>
 <1275552269.27810.34949.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275552269.27810.34949.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:04:29AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-02 at 20:18 -0700, mark gross wrote:
> > However; one could go to a dual list (like the scheduler) and
> > move inactive nodes from an active to inactive list, 
> 
> /me suggests you take a new look at the scheduler, those lists
> disappeared more than 10 releases ago. We use RB-trees these days.

your dating me ;)

I haven't taken a hard look at the scheduler for a while.

/me hides.

--mgross
