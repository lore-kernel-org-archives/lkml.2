Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2EDGQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:16:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39900 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2EDGQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:16:29 -0400
MIME-Version: 1.0
In-Reply-To: <DEAA41EB-6F96-4C87-BD87-94F9C25A07AF@jonmasters.org>
References: <20120410234527.GA1401@p4.domain>
	<DEAA41EB-6F96-4C87-BD87-94F9C25A07AF@jonmasters.org>
Date: Fri, 4 May 2012 14:16:27 +0800
Message-ID: <CAJRGBZxOo1Z=Ce6Qf9k1rXTonic5T+jbX4K_v5yxEe5cU0hVZg@mail.gmail.com>
Subject: Re: [RFC PATCH] a simple hardware detector for lattency as well as throughput
From: Luming Yu <luming.yu@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, jcm@jonmasters.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 11:27 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> On Apr 10, 2012, at 7:45 PM, Luming Yu wrote:
>
>> The rfc patch reuses some code and idea from jcm's hwlat_detector but
>> target for a broader problem that sometime we need to run a simple few minutes
>> hardware test to understand if there is any hardware latency as well as
>> throughput problem exposed on bare metal or left behind by BIOS or
>> interfered by SMI.
>
> Hey thanks. This is totally something I hoped would eventually go upstream,
> but I never got around to cleaning it up enough for mass consumption beyond
> the use case we had in mind (beating certain folks over the head when they
> have "value add" in BIOS code that causes huge SMIs, and the like, for RT).
>
> Did anyone ever get back to you on this one? I never saw any followup. I
> will be happy to do some testing and help you get this mainlined.

So far you are the only one. :-)
If you can find a maintainer for it, and find a way into mainline,
We probably can make it become a popular tool for hardware enabling.

/l
