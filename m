Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1BOEO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 23:14:27 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42528 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1BOEOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 23:14:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=dki0ndCaNcUTz5YwPfhu30w2z/TYhIgxG2F+ntBCWp6K5M8otiGx25D0ytKqvxlFrR
         WhyeyzSbLmpo4a24IVaZuxOeeWGby/8s9H/UWqv9yB1NcOylFxoICbRspprSJcT4SAvP
         HgqDGWhP85YBYmJEjRT4OCoo/sUKeYycn7898=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110215145849.81116623.sfr@canb.auug.org.au>
References: <AANLkTimM1Tmws46DUyoNGsn+P8WN1XPsRu=L8yPzd=xU@mail.gmail.com>
	<AANLkTikO=5zBCvPbd2MXqgzE_mvnabTtH_e2C5_5bpQv@mail.gmail.com>
	<AANLkTinFOPc+BM8cnPE3SLt7Dc2TFOw1v+bntFu01hpO@mail.gmail.com>
	<201102151030.26956.rusty@rustcorp.com.au>
	<AANLkTi=NG+KTGh57oR6Ahq34PohdL5FQFsV+7=4a-J1Z@mail.gmail.com>
	<20110215145849.81116623.sfr@canb.auug.org.au>
Date: Tue, 15 Feb 2011 05:14:24 +0100
Message-ID: <AANLkTin1LV5yOH9C=dzftd=cvqOJH3+OMJOiLhwzVL29@mail.gmail.com>
Subject: Re: [next-20110214] Kernel-modules with unknown parameter
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 4:58 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sedat,
>
> On Tue, 15 Feb 2011 04:34:24 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> On Tue, Feb 15, 2011 at 1:00 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > On Mon, 14 Feb 2011 11:45:59 pm Sedat Dilek wrote:
>> >> >> Any idea what's going on? Stephen, Randy noticed the same like me?
>> >
>> > Dmitry broke module parameters with a "trivial" transform which turned out
>> > not to be.
>> >
>> > I wasn't paying enough attention, and let it through.
>> >
>> >> My damn brain can't understand - looking at the series file in [2] -
>> >> why the hell the "possible" patch [3] is not included in linux-next?
>> >
>> > There are markers in the series file, which indicate what goes into
>> > linux-next.
>>
>> Thanks for the explanations, it makes things seen from the
>> patch-management side a bit clearer.
>>  ( Not sure if the series files was modified in the meantime. )
>>
>> Here for documentation-purposes-only (partially extracted):
>>
>> [ http://ozlabs.org/~rusty/kernel/rr-latest/series ]
>>
>> # NEXT_PATCHES_START
>> # MM_PATCHES_START
>> # Trivial compilation fixes.
>>
>>
>> ## for-linus
>> virtio:virtio-net-add_schedule_check_to_napi_enable_call.patch
>> ## for-linus end
>> module:deal_with_alignment_issues_in_built_in_versions.patch
>> module:do_not_hide_modver_version_show_declaration_behind_ifdef.patch
>> virtio:blk_allow_re_reading_config_space_at_runtime.patch
>> # MM_PATCHES_END
>> # NEXT_PATCHES_END
>>
>> [ / http://ozlabs.org/~rusty/kernel/rr-latest/series ]
>
> That is how it looks today.  Yesterday, the patch
> module:deal_with_alignment_issues_in_built_in_parameters.patch
> was also included and that is what caused the problem.
>
>> Looks to me, the FIXUP patch marked with ***** was not really applied
>> to linux-next?
>
> No, instead the breaking patch (above) was removed from Rusty's
> linux-next series today.
>
>> Also, this fixup patch is no more in Rusty's series file.
>> Is that all correct now?
>
> Rusty has a new version of the above patch which includes the fix (I
> assume) but it is not included in linux-next today.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Hmm, would be nice to have a clarification or a confirmation after
compilation and kernel-modules are loaded correctly on i386 (amd64)
arch(s).

- Sedat -
