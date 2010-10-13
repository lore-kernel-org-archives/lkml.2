Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0JMI4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:56:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58024 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab0JMI4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:56:01 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <AANLkTiki_Sky6pry+vWAoTtJ5ctVUpawAH6iRYV6L-+z@mail.gmail.com>
References: <1286788315.3101.11.camel@sven> <1286955116-22793-1-git-send-email-ohad@wizery.com>
 <AANLkTiki_Sky6pry+vWAoTtJ5ctVUpawAH6iRYV6L-+z@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 13 Oct 2010 10:55:39 +0200
Message-ID: <AANLkTimTSPU3pzDscG3TSaqs45Q=eGEaqiDmk9AYyuY_@mail.gmail.com>
Subject: Re: [PATCH] sdio: fix suspend/resume regression
To: Vitaly Wool <vitalywool@gmail.com>
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

Hi Vitaly,

On Wed, Oct 13, 2010 at 9:54 AM, Vitaly Wool <vitalywool@gmail.com> wrote:
> what about moving this logic to sdio bus_ops as this seems to be
> completely specific to sdio right now?

I actually prefer not to have any SDIO-specific logic of that kind at
all, and instead, to use the logic we already have in mmc_pm_notify
for all types of MMC buses.

I resent this patch in the hope of stimulating this discussion, since
it seemed to have stalled since the last message:

http://lkml.org/lkml/2010/10/11/70

It seems to work ;)

Thanks,
Ohad.
