Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2BIOxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab2BIOxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:53:10 -0500
Date: Thu, 9 Feb 2012 09:53:05 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: update documentation
Message-ID: <20120209145305.GD5650@redhat.com>
References: <4F323B21.7080003@oss.ntt.co.jp>
 <20120208184337.GU5650@redhat.com>
 <20120209074335.GA18387@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120209074335.GA18387@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 08:43:35AM +0100, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Wed, Feb 08, 2012 at 06:06:41PM +0900, Fernando Luis Vázquez Cao wrote:
> > > The soft and hard lockup detectors are now built on top of the hrtimer
> > > and perf subsystems. Update the documentation accordingly.
> > 
> > > Subject: [PATCH] watchdog: update documentation
> > > 
> > > From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > > 
> > > The soft and hard lockup detectors are now built on top of the hrtimer
> > > and perf subsystems. Update the documentation accordingly.
> > 
> > I am fine with this (just need to address Randy's little 
> > fixup).
> > 
> > Ingo, should I take this in and repost for you or just ack it 
> > and let someone like Andrew take this in?
> 
> Yeah, would be nice to have it with Randy's ack and your 
> signoff, can apply it then.

Ok, thanks!

Cheers,
Don
