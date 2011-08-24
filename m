Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1HXRsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:48:52 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:41823 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1HXRsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:48:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [GIT PULL] drbd-8.4 for mainline
Date: Wed, 24 Aug 2011 19:48:40 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.6.2; i686; ; )
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
References: <201108241641.42676.philipp.reisner@linbit.com> <CAGZ=bq+A1ExZYRnuBBwfAq7Ez37mpBtT1_T91AWcchDBZ3iqPw@mail.gmail.com>
In-Reply-To: <CAGZ=bq+A1ExZYRnuBBwfAq7Ez37mpBtT1_T91AWcchDBZ3iqPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241948.40982.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 24 August 2011, 18:00:02 schrieb Kyle Moffett:
> On Wed, Aug 24, 2011 at 10:41, Philipp Reisner
> 
> <philipp.reisner@linbit.com> wrote:
> > Hi Jens,
> > 
> > First the announcement of drbd-8.4, then the git pull-request text:
> > 
> > We are proud to announce the availability of DRBD-8.4.0.
> > 
> >  The most noticeable change is the support for multiple replicated
> >  volumes in a single DRBD connection.
> >  Write-ordering is obeyed among all writes in all volumes in a
> >  single connection.
> >  This feature is really important for users who DRBD for mirroring
> >  over longer distances. (Protocol A).
> > 
> > We do not only release DRBD-8.4.0 today:
> > The DRBD User's Guide was reviewed and updated to match DRBD-8.4.
> > 
> > I suggest to everybody who considers to upgrade from 8.3 to 8.4
> > to have a look at the "Recent changes" appendix of the UG:
> > http://www.drbd.org/users-guide/ap-recent-changes.html
> > 
> >  This release brings a new meta-data format. Forward (8.3 -> 8.4)
> >  conversion happens complete seamless. Backward conversion
> >  is done by a single command (drbdadm apply-al res).
> > 
> >  This release is protocol compatible with all it predecessor.
> >  Although, we do not recommend to run it in 8.3 - 8.4 for long
> >  time frames. We recommend to use that capability only for the
> >  rolling upgrade.
> > 
> >  drbdadm of 8.4 can parse config files of 8.3. We recommend
> >  to switch to the new configuration syntax after the upgrade
> >  of both nodes. (Use drbdadm dump to learn about the new
> >  config syntax)
> 
> Hm...
> 
> That's a lot of patches (including some protocol changes) that have not
> yet been reviewed by other kernel developers.
> 
> By officially releasing the kernel and user-space bits and then posting
> them to LKML and expecting them to be merged as-is, you are not really
> following the linux kernel development process.
> 
> Some of the reverts and commit messages make me concerned that your
> patch series has bisection issues; are you sure it compiles and runs
> after every patch?
> 

Yes I am, since I explicitly tested that after each and every patch. (Though
you are right, we have issues in this regard in our out of tree code).

Some warnings get introduced along the way, and cleaned up later, but
it compiles after each patch.

Best,
 Phil
