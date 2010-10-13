Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0JMJGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:06:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56711 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0JMJGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XWJNCoJAYsTSUHTcB/UwldJUm5t4ipJr2em09irakc3DByI8RN+Ks1E0BxcGE/74t/
         AWnmpFWgikq2vT+GPFAWFeLEUdPof19rRZpNmMFsCWIKZFDOMdvRNj/dFO7mOsuD0Lzh
         a8RkH7IPkerF6eqN876frfBPacbCiinn0Zcjk=
MIME-Version: 1.0
In-Reply-To: <AANLkTimTSPU3pzDscG3TSaqs45Q=eGEaqiDmk9AYyuY_@mail.gmail.com>
References: <1286788315.3101.11.camel@sven>
	<1286955116-22793-1-git-send-email-ohad@wizery.com>
	<AANLkTiki_Sky6pry+vWAoTtJ5ctVUpawAH6iRYV6L-+z@mail.gmail.com>
	<AANLkTimTSPU3pzDscG3TSaqs45Q=eGEaqiDmk9AYyuY_@mail.gmail.com>
Date: Wed, 13 Oct 2010 11:06:51 +0200
Message-ID: <AANLkTi=oM6bzga1HffOxZ6_T7yjSNi5RTCZtTFd4r=7j@mail.gmail.com>
Subject: Re: [PATCH] sdio: fix suspend/resume regression
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        libertas-dev@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>,
        Sven Neumann <s.neumann@raumfeld.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Mack <daniel@caiaq.de>,
        Colin Cross <ccross@android.com>, Chris Ball <cjb@laptop.org>,
        stable@kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 10:55 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Vitaly,
>
> On Wed, Oct 13, 2010 at 9:54 AM, Vitaly Wool <vitalywool@gmail.com> wrote:
>> what about moving this logic to sdio bus_ops as this seems to be
>> completely specific to sdio right now?
>
> I actually prefer not to have any SDIO-specific logic of that kind at
> all, and instead, to use the logic we already have in mmc_pm_notify
> for all types of MMC buses.

I don't really see the point. Instead of having SDIO-specific handling
in the SDIO specific code, we're trying to address SDIO specific
corner cases elsewhere. What's the rationale?

Thanks,
   Vitaly
