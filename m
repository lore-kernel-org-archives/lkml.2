Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab0E0VJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:09:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab0E0VJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:09:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Thu, 27 May 2010 23:10:50 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271327560.3239-100000@iolanthe.rowland.org> <1274981533.27810.5624.camel@twins>
In-Reply-To: <1274981533.27810.5624.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005272310.50724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 13:29 -0400, Alan Stern wrote:
> > 
> > They may be different conceptually.  Nevertheless, Android uses forced 
> > suspend as a form of power saving.  Until better mechanisms are in 
> > place, it makes sense. 
> 
> So let them, doesn't mean we have to merge it. Or will you saw your foot
> off too if google were to promotes it?

Do you have to be offensive to people who disagree with you?

Alan simply wants to understand the _technical_ objections that people have
to this patchset and you're not helping.  So, could you please explain what
exactly is your technical objection to it?

Rafael
