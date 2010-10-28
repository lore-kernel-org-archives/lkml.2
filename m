Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab0J1LeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:34:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55962 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261Ab0J1Ld6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fHEMdpIiClihbGoZQEgleOtRpGX33YZmJ4fPFEHvybI7Pnt/mSygG53fnF8BARSawl
         8G5lyQbQHmMqq5JqWb2FGJMbM0JGiqlZWTZqUgK/wackbFYQGu9ALjvmbLp3VPq8mmPi
         40+f5bf/6hr438R4ogBZ8VI0bosJrbQLyL2ZM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
	<AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
	<AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
	<AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
	<AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
	<20101028090002.GA12446@elte.hu>
	<AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
Date: Thu, 28 Oct 2010 17:33:57 +0600
Message-ID: <AANLkTikyYQk1FH7d6jkw2GYHLN8jmghuGZQw=EFVgjuA@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Aidar Kultayev <the.aidar@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if it wasn't picasa, it would have been something else. I mean if I
kill picasa ( later on it was done indexing new pics anyway ), it
would have been for virtualbox to thrash the io. So, nope, getting rid
of picasa doesn't help either. In general the systems responsiveness
or sluggishness is dominated by those io operations going on - the DD
& CP & probably VBOX issuing whole bunch of its load for IO.

Another way I see these delays, is when I leave system overnight, with
ktorrent & juk(stopped) in the background. It takes some time for
WM(kwin) to work out ALT+TAB the very next morning. But this might be
because the WM(kwin & its code) has been swapped out, because of long
period of not using it.

But, in general, I have troubles with responsiveness, when I try to
restore my virtualbox image from saved state. If there is a DD doing
its stuff while virtualbox is restoring its image, I see those nasty
delays - the kwin, mouse pointer, etc...

thanks Aidar

PS : the good thing is, and I am getting used to it, I don't loose
data, I mean the system doesn't hang, just freezes for a while :)

On Thu, Oct 28, 2010 at 5:16 PM, Pekka Enberg <penberg@kernel.org> wrote:
> * Pekka Enberg <penberg@kernel.org> wrote:
>>> On Thu, Oct 28, 2010 at 9:09 AM, Aidar Kultayev <the.aidar@gmail.com> wrote:
>>> > Find attached screenshot ( latencytop_n_powertop.png ) which depicts
>>> > artifacts where the window manager froze at the time I was trying to
>>> > see a tab in Konsole where the powertop was running.
>>>
>>> You seem to have forgotten to include the attachment.
>
> On Thu, Oct 28, 2010 at 12:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> I got it - it appears it was too large for lkml's ~500K mail size limit.
>>
>> Aidar, mind sending a smaller image?
>
> Looks mostly VFS to me. Aidar, does killing Picasa make things
> smoother for you? If so, maybe the VFS scalability patches will help.
>
>                        Pekka
>
