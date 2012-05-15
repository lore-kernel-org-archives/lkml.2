Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2EOFyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 01:54:01 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57468 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab2EOFyA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 01:54:00 -0400
MIME-Version: 1.0
In-Reply-To: <87397by2h9.fsf@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<87397by2h9.fsf@ti.com>
Date: Tue, 15 May 2012 11:16:53 +0530
Message-ID: <CAJ6a13aJwesHw0frCV+EfvYaep09cZGcu_PopuHzye1HS2tgvg@mail.gmail.com>
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        j-pihet@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 5:21 AM, Kevin Hilman <khilman@ti.com> wrote:
> Rafael,
>
> Keerthy <j-keerthy@ti.com> writes:
>
>> From: J Keerthy <j-keerthy@ti.com>
>>
>> AVS(Adaptive Voltage Scaling) is a power management technique which
>> controls the operating voltage of a device in order to optimize (i.e. reduce)
>> its power consumption. The voltage is adapted depending on static factors
>> (chip manufacturing process) and dynamic factors (temperature
>> depending performance).
>> The TI AVS solution is named Smartreflex.
>>
>> To that end, create the AVS driver in drivers/power/avs and
>> move the OMAP SmartReflex code to the new directory. The
>> class driver is still retained in the mach-omap2 directory.
>
> How should we handle this for upstream?
>
> It does a bunch of cleanup under arch/arm then does the move to
> drivers/power the end.  To avoid conflicts with other OMAP core changes,
> I would suggest we take this through the OMAP tree.
>
> With your ack, I'd be glad to take it.

Hello Rafael,

A gentle ping on this series.

>
> Thanks,
>
> Kevin
>



-- 
Regards and Thanks,
Keerthy
