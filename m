Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2LRR34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:29:56 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59173 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab2LRR3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:29:55 -0500
X-Greylist: delayed 7235 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 12:29:55 EST
MIME-Version: 1.0
In-Reply-To: <1355851688.1414.18.camel@x61.thuisdomein>
References: <1355779884.1414.14.camel@x61.thuisdomein>
	<50D0473D.9060106@vodafone.de>
	<CADnq5_ORb_kdaehxR6y+P1S0eStiLEo7jFOYXhn4sMDw5b=bcw@mail.gmail.com>
	<1355851688.1414.18.camel@x61.thuisdomein>
Date: Tue, 18 Dec 2012 12:29:54 -0500
Message-ID: <CADnq5_NyYA3pkUPxHPp8LzDJ3HnEWD1oJ2r93E2n-urBaLWm7w@mail.gmail.com>
Subject: Re: [PATCH] [RFC] drm/radeon: return 0 on successful gpu reset
From: Alex Deucher <alexdeucher@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 12:28 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2012-12-18 at 10:22 -0500, Alex Deucher wrote:
>> On Tue, Dec 18, 2012 at 5:36 AM, Christian König
>> <deathsimple@vodafone.de> wrote:
>> > On 17.12.2012 22:31, Paul Bolle wrote:
>> >> 1) Sent as an RFC because I do not understand why this laptop (almost
>> >> always) prints the "crtc 1" message on first resume. Note that another
>> >> workaround for this hang is simply booting with "radeon.tv=0".
>> >
>> > Alex should probably take a look into this, since he probably is the one
>> > with the deepest knowledge of the display engine. My best guess is that it
>> > is just some error while probing for an attached TV and actually isn't so
>> > bad after all.
>>
>> TV detection is always a bit flakey.  I suspect some register or gpio
>> related to TV out doesn't get restored properly on resume which
>> results in a false positive.  What asic is this?
>
> It's an RV250, which makes the asic r200, doesn't it?

Yes, it's an r2xx variant.

>
>> > You should definitely try Alex latest drm-fixes-3.8 branch
>> > (git://people.freedesktop.org/~agd5f/linux) since the possibility is quite
>> > high that we already have fixed that bug. If that doesn't helps then please
>> > open a bug report and leave me a note so that I can investigate further.
>>
>> I don't have a 3.8 fixes branch up just yet, but will soon.
>
> I see. I'll watch that repository, but I would appreciate it if you
> notify me if that branch pops up.

Will do.

Alex
