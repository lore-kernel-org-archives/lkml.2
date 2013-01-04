Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3ADGLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 01:11:38 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43390 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3ADGLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 01:11:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130101011158.GA7601@joi.lan>
References: <1356917699-19479-1-git-send-email-aaro.koskinen@iki.fi>
	<20130101011158.GA7601@joi.lan>
Date: Fri, 4 Jan 2013 16:11:34 +1000
Message-ID: <CAPM=9tx6GsQ4CygSrzUj9MoCyvAtU1L++=OGnxCWRZCgRa7VYw@mail.gmail.com>
Subject: Re: [RESEND PATCH] drm/nouveau: fix init with agpgart-uninorth
From: Dave Airlie <airlied@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Ben Skeggs <skeggsb@gmail.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stefan@konink.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 1, 2013 at 11:21 AM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Mon, Dec 31, 2012 at 03:34:59AM +0200, Aaro Koskinen wrote:
>> Check that the AGP aperture can be mapped. This follows a similar change
>> done for Radeon (commit 365048ff, drm/radeon: AGP memory is only I/O if
>> the aperture can be mapped by the CPU.).
>>
>> The patch fixes the following error seen on G5 iMac:
>>
>>       nouveau E[     DRM] failed to create kernel channel, -12
>>
>> Reviewed-by: Michel Dänzer <michel@daenzer.net>
>> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>> ---
>
> This patch fixes https://bugs.freedesktop.org/show_bug.cgi?id=58806.
> For some (weird) reason Nouveau worked on this configuration on 3.6 kernel,
> so cc'ing stable@vger seems to be appropriate.

Cool I've picked this up and applied it for stable into fixes now.

Dave.
