Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1FJSJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:09:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54405 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757Ab1FJSJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=m5r3k3sa9gI7FdDsQJZxSPRVFQsJp6+LVH3BneZYOT+chnVUuS+88rIgBgI2Wxm+mX
         vP69GIbKIJlAegU/G1SSdrBx4Rq4yAvCdV6lz/FcDuid6RyJDL8YZ835c3WC+UUhqdFl
         b45OgPch7lwF4ud2MVNj8WwIbEU3rpyHQViFk=
MIME-Version: 1.0
In-Reply-To: <20110610180755.GR26436@opensource.wolfsonmicro.com>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <20110610172734.GI26441@sirena.org.uk> <BANLkTimN0-a++2Nd13rHGSwkVPDxU8GBhQ@mail.gmail.com>
 <20110610180755.GR26436@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 10 Jun 2011 14:08:45 -0400
Message-ID: <BANLkTikzuin+n3Pohfff44vA-PEGPwWOYg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: Add ADAU1701 codec driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 14:07, Mark Brown wrote:
> On Fri, Jun 10, 2011 at 01:44:00PM -0400, Mike Frysinger wrote:
>> On Fri, Jun 10, 2011 at 13:27, Mark Brown wrote:
>> > Also someone should remonstrate with the hardware designers.
>
>> if there's things we can take back, i can forward them along.  the
>> last conversation i had with them sounded like they have no problem
>> accepting feedback.
>
> I was referring to the fact that different registers have different
> sizes which does rather complicate the code.

np.  i'll forward that along.  "uniform codec register sizes simplifies code".
-mike
