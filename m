Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab2ENWQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:16:30 -0400
Received: from apollo.dupie.be ([94.75.207.143]:46996 "EHLO apollo.dupie.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900Ab2ENWQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:16:28 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 18:16:28 EDT
Message-ID: <4FB182BB.6090303@dupond.be>
Date: Tue, 15 May 2012 00:10:03 +0200
From: Jean-Louis Dupond <jean-louis@dupond.be>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Mario Limonciello <mario_limonciello@dell.com>,
        Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
References: <1337023652-11661-1-git-send-email-kamal@canonical.com> <20120514193718.GA6438@srcf.ucam.org> <4FB16659.6040704@dell.com> <20120514211959.GA9394@srcf.ucam.org> <4FB1774D.4080106@dell.com> <20120514212842.GA9561@srcf.ucam.org> <4FB17DA8.1040808@dell.com> <20120514215533.GA10378@srcf.ucam.org>
In-Reply-To: <20120514215533.GA10378@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm the owner of a XPS 15, which has this issue.
The best solution would indeed be to solve the real bug, and not work
around it in Linux.

But still, if we can fix it with rather small impact/code on linux, I
think we should just do it.
It makes linux more user friendly this way.

A small remark also:
Is it really possible to disable bluetooth without killing wifi in
Windows on the XPS?
Not that I use windows alot, but it doesn't seem to work perfectly in
windows neither.
This bug is prolly not very common, as default XPS doesn't have a
bluetooth chip.


Thanks
Jean-Louis

Op 14-05-12 23:55, Matthew Garrett schreef:
> On Mon, May 14, 2012 at 04:48:24PM -0500, Mario Limonciello wrote:
>
>> The problems were exposed on newer XPS laptops because those platforms 
>> were not tested during platform development.  There really isn't a 
>> scalable way to represent whether a platform was or wasn't tested 
>> during development.  In a lot of situation things just work.  I would 
>> like to do the right thing for the users with what information and 
>> resources are available right now to put them in a better state.  An 
>> aggressive approach of not taking patches to cover a broken interface 
>> won't fix the problem of not testing machines already in the market, 
>> it will just put end users of the kernel module at a disadvantage.
> That's why it's better to just remove the interface. Providing a feature 
> when we know it's broken on some unknown subset of hardware doesn't 
> benefit anyone. If even Dell don't have any idea which set of machines 
> it works on then how are we ever expected to make sure it's correct?
>
>> 1) Don't blacklist any Latitude or Vostro.  These are tested during platform development.
>> 2) Leave those compal_laptop supported ones blacklisted.
>> 3) Blacklist 2010-2012 XPS.  These are currently not tested during platform development.
>> 4) If problems start to show up on Inspiron, blacklist them invidually.  These platforms are currently tested during platform development though, so hopefully issues don't crop up.
> Is this the set of criteria that the Windows tools use? If so, I'll 
> implement it. If not, then either provide the set of criteria that the 
> Windows tools use or I'll remove the interface.
