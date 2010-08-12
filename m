Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab0HLA2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:28:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38167 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376Ab0HLA2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y66bJ463AD5xbWpNeSyDkgHZ/CX65KnRYHYDQRCO9AsPJH1XjYDOsSsR3Ga3tAgLPu
         sklEpR0GmfetqqQMQd9MuUbTZoHNkmzzDIGWBHpdeik6PAU+OvQ76/ZggwbvGlEpWhZp
         aNEIJiitrg8iUuFKPYt8GZNYiI5WSieMnhO0w=
MIME-Version: 1.0
In-Reply-To: <20100811222854.GJ2516@linux.vnet.ibm.com>
References: <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
	<20100811222854.GJ2516@linux.vnet.ibm.com>
Date: Thu, 12 Aug 2010 03:28:00 +0300
Message-ID: <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 1:28 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Aug 11, 2010 at 10:18:51PM +0300, Felipe Contreras wrote:
>> On Mon, Aug 9, 2010 at 9:16 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > But wouldn't an office suite run as a power-oblivious application on an
>> > Android device?  After all, office applications do not need to run when
>> > the screen is turned off, so these the applications do not need to use
>> > suspend blockers.
>>
>> Ideally the system would be suspended even when the screen is on. If
>> there are no "trusted" applications running at the same time, then
>> openoffice wouldn't load at all. Right?
>
> My understanding is that Android systems in fact do not suspend when
> the screen is on, and that most (perhaps all) other systems do not
> opportunistically suspend at all.  There has been some speculation about
> what a hypothetical Android having a non-volatile display might do,
> but as far as I know, this is just speculation.

I have a desktop system in mind. If opportunistic suspend is only
triggered when the display is off, then it's no good for normal usage,
and therefore dynamic PC needs to get its act together... specially
for laptops.

-- 
Felipe Contreras
