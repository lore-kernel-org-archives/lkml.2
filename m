Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0EQTBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:01:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60622 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0EQTBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kX2RFG9ELR81sD0d594SNwn4gkZql73Bo9hAc+QqRQcYaZrILXpy+oZE8Kk8kUZX74
         dAJEWhfkxWJrANIfhallGKNdFwWppfF4KIwfjrGIDrcd4/W+4z5B6b6N0neKtJVR2GwJ
         ksfBC46VC2KaJf9Hgkdpp1iRUtvrLgxy9vMiQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTilX0uhqrJtUSOC4smdH1M8V-h14J7YtRG4PPxOQ@mail.gmail.com>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	 <201005142308.48386.rjw@sisk.pl>
	 <AANLkTilX0uhqrJtUSOC4smdH1M8V-h14J7YtRG4PPxOQ@mail.gmail.com>
Date: Mon, 17 May 2010 15:01:19 -0400
Message-ID: <AANLkTilE4bLZql7W0manAfJUp-S03jK-hUjLfNFxVFcx@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
From: Mike Snitzer <snitzer@gmail.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/17 Arve Hjønnevåg <arve@android.com>:
> 2010/5/14 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Friday 14 May 2010, Arve Hjønnevåg wrote:
>>> This patch series adds a suspend-block api that provides the same
>>> functionality as the android wakelock api. This version has some
>>> changes from, or requested by, Rafael. The most notable changes are:
>>> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
>>>   for statically allocated suspend blockers.
>>> - suspend_blocker_destroy is now called suspend_blocker_unregister
>>> - The user space mandatory _INIT ioctl has been replaced with an
>>>   optional _SET_NAME ioctl.
>>>
>>> I kept the ack and reviewed by tags on two of the patches even though
>>> there were a few cosmetic changes.
>>
>> Thanks for the patches, I think they are in a pretty good shape now.
>>
>> That said, I'd like the changelogs to be a bit more descriptive, at least for
>> patch [1/8].  I think it should explain (in a few words) what the purpose of
>> the feature is and what problems it solves that generally a combination of
>> runtime PM and cpuidle is not suitable for in your opinion.  IOW, why you
>> think we need that feature.
>>
>
> How about:
>
> PM: Add opportunistic suspend support.
>
> Adds a suspend block api

In the future I think it'd be ideal if you were to always use "suspend
blocker" (rather than "suspend block").

This work has nothing to do with the block layer yet by the subject I
thought it somehow did.
