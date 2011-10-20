Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1JTVQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:16:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56065 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab1JTVQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:16:13 -0400
Date: Thu, 20 Oct 2011 17:16:00 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Phillip Lougher <phil.lougher@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        greg@kroah.com, linux-kernel@vger.kernel.org,
        phillip@lougher.demon.co.uk
Subject: Re: Procedural requirements for restoring kernel.org accounts
Message-ID: <20111020211600.GC16820@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Phillip Lougher <phil.lougher@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, greg@kroah.com,
	linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk
References: <20111014152100.GA11717@kroah.com>
 <4E988564.40905@zytor.com>
 <CA+2-8GA-R3TETVLubOO8uMQq1a3-LmQ=STrXM1kf+8WbgfhTLQ@mail.gmail.com>
 <20111020220922.6bfed01b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020220922.6bfed01b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 10:09:22PM +0100, Alan Cox wrote:
> > this.  So, will there be another key signing session held during the
> > three days of LCE, and will the procedure mentioned in the link above
> > ("If you would like to participate, please send an e-mail to
> > prague-key-submission@googlegroups.com") apply too?
> 
> That sounds a good plan because I suspect LCE will have a number of
> kernel hackers around who are not at KS, and KS will have plenty of us
> who have gone home before LCE.

I was looking into setting up a separate key signing event at LCE, but
the schedule is really packed, so it wasn't clear we could find a slot
that would work for everyone.  Also, I simply ran out of time to try
to organize yet another key signing event.

This is why I suggested a more informal approach of people
pre-printing fingerprints on slips of paper which could be exchanged,
using something like gpg-key2ps.  If everyone comes prepared with
these slips of paper, we can either try to organize a room where it's
easier for people to find each other, or it can be done in an ad-hoc
fashion during the coffee/tea breaks.

						- Ted

