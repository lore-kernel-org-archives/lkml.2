Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab0LHSUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:20:14 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35818 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab0LHSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ERkVvZbgd40I4+VOGM3Iqny/Q/lNBBxIYcKwg5MGR4xwAKSLf2DkXvUjz6ivmjXPSE
         GokSW8t7KYxmCwbjuH9CRl4fSAGzspRgnNNNozLDN+VGX4B7bvM08wXOyNZB6oL8j4FX
         Vs3ASkOKByuLAzjXCdYcqV77KxN/VyO2CwOG8=
MIME-Version: 1.0
In-Reply-To: <20101208180521.GA31522@core.coreip.homeip.net>
References: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
	<4CFFC45C.2040107@canonical.com>
	<20101208180521.GA31522@core.coreip.homeip.net>
Date: Wed, 8 Dec 2010 10:20:10 -0800
Message-ID: <AANLkTinKVcc3KA3S_7-vwQWtDuUFZ2LSmjgrCrZXcRw5@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Add hovering distance axis
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 10:05 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Dec 08, 2010 at 09:46:04AM -0800, Chase Douglas wrote:
>> On 12/07/2010 12:27 AM, Henrik Rydberg wrote:
>> > Touch devices capable of hovering, i.e., fingers detected a distance
>> > from the surface, are not supported by the current input MT
>> > protocol. This patch adds ABS_MT_DISTANCE, which may be used to
>> > indicate the distance between the contact and the surface.
>>
>> Have you given thought to calling it ABS_MT_Z instead? I have no real
>> problem with ABS_MT_DISTANCE per se, but ABS_MT_Z is more clearly
>> defined in my head. If I was new to MT development I may wonder if
>> ABS_MT_DISTANCE had anything to do with distance between points or some
>> other object.
>
> X/Y/Z imply that we fully engaged the device and it is 3 dimensional.
> Distance says that we are approaching the device but have not directly
> engaged it yet.
>
> I think ABS_DISTANCE was added at Pings request and ABS_MT_DISTANCE is
> modeled after ST one. Ping, could you refresh my memory why we needed
> ABS_DISTANCE?

ABS_DISTANCE is used in wacom driver as the distance between the tool
tip and the tablet.

Ping
