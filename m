Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0HKWDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:03:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39846 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0HKWDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KTuYp+dYQWh92i5kQrgMRZcuowwxFuuVblpAvDKb5gCg1eRFc1YI6wOon/DAoyIvHB
         Y8hltXQUuow9T7IgNpSaySF+cyC0kZl1YzbYB+Ovt9fB9/lhYIVd7wTAAd5AJgSRDOV0
         c+h9oe4mHFbR7uD1oEoJcsv+Vxq91eajLJLzs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinOb5PsrLbMzbYVqqx=6n-yPNRCYgOf4fM5KdXJ@mail.gmail.com>
References: <20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<AANLkTinNc1SWmz8pE_4k6vThxQCJfCR_UqV6OM=OsJOf@mail.gmail.com>
	<20100811193106.GB24435@thunk.org>
	<AANLkTinBrp1iHWAi=vk_eaEHMs+Xcub6rg8PgT_LK2c9@mail.gmail.com>
	<AANLkTinOb5PsrLbMzbYVqqx=6n-yPNRCYgOf4fM5KdXJ@mail.gmail.com>
Date: Thu, 12 Aug 2010 01:03:46 +0300
Message-ID: <AANLkTimAKwDPYZeCj_UEyXf-6DxLg8=Zi-=tFKzzgvQi@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:37 AM, Brian Swetland <swetland@google.com> wrote:
> On Wed, Aug 11, 2010 at 2:25 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> Now, only Android has decided to use suspend blockers, that's a
>> *fact*, and I wanted to narrow the discussion to Android in order to
>> make it easier to understand that Android doesn't need suspend
>> blockers, once we have agreed that, then I'd gladly discuss it's
>> merits outside Android.
>
> On behalf of the Android folks, we don't agree with this.  If you're
> going to wait until we suddenly change our minds, I think you're going
> to be in for a long wait.

I'm sure as a team that's the case, but you can't know what's in the
mind of everyone at Google (not Android).

>> I argued to you that suspend-blockers are not required in Android, and
>> suddenly you decide we should agree to disagree without arguing back?
>> Well, suit yourself. I still maintain that suspend-blockers is just an
>> expensive workaround, and in some cases actually degrades power
>> consumption; the right solution is much more sophisticated.
>
> Once "the right solution" exists and solves our problems, we'll
> certainly look into switching over to it.  I've yet to see a proposal
> in all this arguing that appears to me to be an improvement over what
> we have today with suspend blockers.  I find the "don't do what you're
> doing because someday, somebody will do it better" to be an
> uncompelling argument.

That was not an argument, it was an opinion. If you want an argument
go back to read this one:
http://article.gmane.org/gmane.linux.kernel/1021834

> Given your opinion that Android lacks multitasking (what? really?)

This is what I'm talking about when I say multi-tasking, Android
certainly doesn't have anything remotely like that:
http://www.youtube.com/watch?v=7emvUBpEkbU

-- 
Felipe Contreras
