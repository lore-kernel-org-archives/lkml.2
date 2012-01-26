Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab2AZGVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 01:21:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35605 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2AZGVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 01:21:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxTAHTXRmnK9AeJm525u28SGRxCRMAvY8rJcNuwkHANtg@mail.gmail.com>
References: <alpine.DEB.2.00.1201251902590.12477@skynet.skynet.ie>
	<CA+55aFxTAHTXRmnK9AeJm525u28SGRxCRMAvY8rJcNuwkHANtg@mail.gmail.com>
Date: Thu, 26 Jan 2012 01:21:16 -0500
Message-ID: <CAH3drwaMEEts6g9iJ83raJO0DK_5VTOy7zWa_exqMghEJ6mzpQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Jerome Glisse <j.glisse@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 6:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jan 25, 2012 at 11:05 AM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> bunch of regression fixes since TTM rework and radeon initialisation,
>> modesetting fixes for Alex to fix some black screens on kms start type
>> issues, and two radeon ACPI fixes that make some laptops no oops on
>> startup.
>
> Does that include for the nvidia (?) suspend/resume issue? You were
> cc'd on it (but the subject may have made you ignore it - it was part
> of a thread about wireless network suspend issues: "bcma/brcmsmac
> suspend/resume cleanups and fixes"):
>
>  No trivial bisect. I wish I had a faster build machine, but alas. I
>  suspected some issue in DRM and the bisect took me into drm-core-next
>  branch. I ended up at the following commit:
>
>  dc97b3409a790d2a21aac6e5cdb99558b5944119 is the first bad commit
>  commit dc97b3409a790d2a21aac6e5cdb99558b5944119
>  Author: Jerome Glisse <jglisse@redhat.com>
>  Date:   Fri Nov 18 11:47:03 2011 -0500
>
> Hmm?
>
>                     Linus

Ben Skeggs patch fix this issue.

Cheers,
Jerome
