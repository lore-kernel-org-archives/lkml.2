Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0FAUMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:12:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43255 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab0FAUMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:12:42 -0400
Date: Tue, 1 Jun 2010 22:12:30 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: markgross@thegnar.org, 640e9920@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601221230.7f7d892b@schatten.dmk.lab>
In-Reply-To: <20100601220035.6b47d57d@schatten.dmk.lab>
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
	<Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
	<AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
	<201005312338.55109.rjw@sisk.pl>
	<20100531232617.GF31155@gvim.org>
	<20100601090737.4bc243d9@schatten.dmk.lab>
	<20100601140519.GC1281@gvim.org>
	<20100601220035.6b47d57d@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 22:00:35 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Tue, 1 Jun 2010 07:05:19 -0700
> mark gross <640e9920@gmail.com> wrote:
> 
> > 
> > Only works 1/2 the time, but I like the idea!  
> > It fails to get the righ answer when constraints are reduced.  But, this
> > idea is a good improvement i'll roll into the next pm_qos update!
> > 
> > thanks!
> > 
> > --mgross
> 
> outch. shure. i had the binary block/unblock case in my mind. (where
> the comparitor would be just the logical &&)

And even there it wouldn't work in general. What about keeping the list
sorted? (Or using the rbtree implementation). Well, I'm getting some
sleep and tomorrow I will think about it some more. 

> cheers,
> Flo
> 
