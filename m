Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1FHNil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:38:41 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40151 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab1FHNik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:38:40 -0400
Date: Wed, 8 Jun 2011 09:38:33 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: John Kacur <jkacur@redhat.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
        linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
Message-ID: <20110608133833.GD30037@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, John Kacur <jkacur@redhat.com>,
	Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
	linux-kernel@vger.kernel.org
References: <4DEE1D96.6020208@profihost.ag>
 <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
 <4DEE2C70.8060301@profihost.ag>
 <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
 <4DEE9EDA.90001@profihost.ag>
 <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
 <BANLkTim3GuppJ4=VHa0BgNV1d4nQjWUcbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim3GuppJ4=VHa0BgNV1d4nQjWUcbg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 10:00:39AM +0200, John Kacur wrote:

> Ok, I don't speak for my company, and your point about not expecting
> people to do this work for you is valid, however I don't see why you
> need to take potshots at Red Hat

It wasn't a potshot; if it is true, it is a completely rational
economic argument that is completely within the bounds of the
requirements of the GPL, and with LKML community standards.

The reason why I say it is because of (a) http://lwn.net/Articles/430098/,
and (b) a few months ago, when I quietly floated starting a new
long-term stable kernel series that a number of companies would
maintain cooperatively, I was told, privately, that such a proposal
would not likely be received positively by Red Hat management because
of the reasons behind the policy instituted by (a).

Which is fine, I don't consider that a potshot, no more than I
consider the fact that IBM forked the OpenOffice before it was
relicensed to the LGPL and made changes which they didn't give back,
and seems to be actively supporting Oracle's attempt to get Apache to
adopt OpenOffice.org inspite of the currently healthy LibreOffice
LGPL3 branch which already has an active community to be a potshot.

Both are completely legal things set by the ground rules of the
copyright licenses involvled, and someone no less than Linus has said
that the ability to fork is healthy because it keeps people honest.

> - they are quite active in the stable effort.
> 
> wget http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.38.8
> grep Author ChangeLog-2.6.38.8 | grep -i redhat | wc -l
> 9
> 
> grep Author ChangeLog-2.6.38.8 | grep -i suse | wc -l
> 10
> 
> grep Author ChangeLog-2.6.38.8 | grep -i canonical | wc -l
> 5
> 
> I'm not even claiming that these are typical stats, but as just a
> quick check on your statement, the contributions for one stable
> release are in the same ballpark as everyone else.

Nah, that just means that commits which are labelled with "CC:
stable@vger.kernel.org" are automatically accepted into stable kernel
series.

If you can point efforts where painful backports of ext4 and xfs bug
fixes into RHEL 6.x are making it back into 2.6.32.y, even though in
some cases it takes tens of hours of engineering and QA efforts, we
can talk.  But please note that I wasn't calling out Red Hat as being
bad or evil by doing what they are doing; it is completely
economically rational and allowed by the GPL rules for them to be
doing what they are doing.  (Just as what Android has been doing with
their constant forward porting of the Wakelocks API is completely
within the GPL rules.)

	       		     		   - Ted
