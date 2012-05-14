Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2ENSJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:09:25 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:46589 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033Ab2ENSJV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <4FAFEB2D.5010009@googlemail.com>
References: <4FAB15DB.5050702@googlemail.com> <20120513122946.GD706@sirena.org.uk>
 <4FAFE1BF.9050805@googlemail.com> <20120513164304.GB6381@opensource.wolfsonmicro.com>
 <4FAFEB2D.5010009@googlemail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 14 May 2012 11:08:58 -0700
Message-ID: <CAJOA=zOXh_+HbtSr8cXXNJWCWJroC2Cy+62y9nx7tdH4ZbhXKw@mail.gmail.com>
Subject: Re: [RFC] Common clock framework for external clock generators
To: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 10:11 AM, Sebastian Hesselbarh
<sebastian.hesselbarth@googlemail.com> wrote:
> On 05/13/2012 06:43 PM, Mark Brown wrote:
>>
>> One of the patches I've been sending adds a dummy clk_unregister() for
>> the sake of making the drivers look nicer - practically speaking it's
>> not likely to be terribly important as these things don't get unloaded
>> terribly often.  It looks like that patch didn't get applied either.
>
>
> Well, of course I don't plan to unload the driver ever but basically it
> is possible..
>

Mark,

Seems like the clk_unregister patch fell through the cracks.  My
mistake.  I'm going to be sending another pull request to arm-soc with
Orion/Kirkwood support.  I'll add your patch in at that time.

Sebastian,

Please CC me on the next revision of your patch.  Mark's review hit
all of the high points for this version.

Regards,
Mike
