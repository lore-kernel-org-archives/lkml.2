Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab2JCRez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:34:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47980 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964779Ab2JCRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:34:53 -0400
Date: Wed, 3 Oct 2012 18:34:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: John Stultz <john.stultz@linaro.org>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>
Message-ID: <20121003173448.GF32217@decadent.org.uk>
References: <20121001225157.951753597@1wt.eu>
 <1349275814.16173.13.camel@deadeye.wl.decadent.org.uk>
 <20121003160151.GE3889@1wt.eu>
 <506C6F59.8050403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506C6F59.8050403@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 008/180] 2.6.32.x: ntp: Fix leap-second hrtimer livelock
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 10:01:13AM -0700, John Stultz wrote:
> On 10/03/2012 09:01 AM, Willy Tarreau wrote:
> >Hi Ben,
> >
> >On Wed, Oct 03, 2012 at 03:50:14PM +0100, Ben Hutchings wrote:
> >>On Tue, 2012-10-02 at 00:52 +0200, Willy Tarreau wrote:
> >>>2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> >>[...]
> >>
> >>No objection, but please remove the '2.6.32.x: ' prefix from the subject
> >>before committing this and the other ntp/timekeeping/hrtimer fixes.
> >Good point. Initially John used this as a differenciator when sending to
> >stable@ but I directly applied the mbox without fixing the subject, which
> >isn't a good thing.
> Do let me know if there's a better way for me to send them (and keep
> the versions straight) without creating more work for you.
 
I can't speak for Willy but I would prefer something like
'[PATCH 3.2.y]' in the subject.  'git am' or any other patch
import script should strip that out.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
