Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1CLXmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 18:42:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56872 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab1CLXmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 18:42:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qczif03iFLI9Y7NcI+G0S9PS1gD0WsE0v0TW0zVPrFXcyJXK/fGJhZVrpOw13D9B2k
         U1WxVnojg0ZmMpP8deyDmYgXZ9TJCngcUTE8aWLcSX55odSXF2/9B//vSBfyGlt3+J3x
         TOlGFx5k68/oUg+TtLqohOc+ui6HONiR1CpQo=
MIME-Version: 1.0
In-Reply-To: <20110312173626.GC24981@kroah.com>
References: <1299889746-16502-1-git-send-email-omar.ramirez@ti.com>
	<20110312173626.GC24981@kroah.com>
Date: Sun, 13 Mar 2011 01:42:35 +0200
Message-ID: <AANLkTinp0e4EiEH=XV9gCSJzoh-VAY-6qqs91x0s80ro@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        l-m <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        l-o <linux-omap@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tuomas Kulve <tuomas@kulve.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 7:36 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Mar 11, 2011 at 06:29:06PM -0600, Omar Ramirez Luna wrote:
>> Please consider to apply this patch in the staging tree, as the
>> description says it fixes a crash in tidspbridge driver, this bug
>> was already present but it seems to have surfaced by recent tests
>> made by Felipe and Tuomas.
>>
>> It is an urgent fix for 2.6.38.
>
> Heh, it's funny to see such a "urgent" fix take so long to get to me :)

Well, depending on your hardware and use-case this might or might not
be urgent. At least for some people the driver is unusable without
this.

> Is it also applicable for .37?

Yes.

> How about I send it to Linus for .39 and then add it to the .38-stable
> tree when it comes out?

That was the plan for .38/.37-stable. I'd say that's fine, but it
would be even better to avoid people getting bit by this on plain .38.

Cheers.

-- 
Felipe Contreras
