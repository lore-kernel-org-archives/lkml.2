Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2D0I3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:29:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59853 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759281Ab2D0I3G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120427082203.GB9233@aftab.osrc.amd.com>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>
	<fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
	<14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
	<4F97BA60.4080505@ladisch.de>
	<20120427082203.GB9233@aftab.osrc.amd.com>
Date: Fri, 27 Apr 2012 11:29:04 +0300
Message-ID: <CABTASCzHqRDHNXLTzfFh7__vv2Zhhr+2X6kKxUxRJ_3Ud2yv=A@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Andrei Matei <andymatei@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How come ASUS is treating its expensive board clients like this? This
issue is going on for months now and nothing happends. I would really
like my money back for this board

On Fri, Apr 27, 2012 at 11:22 AM, Borislav Petkov
<borislav.petkov@amd.com> wrote:
> On Wed, Apr 25, 2012 at 10:48:32AM +0200, Clemens Ladisch wrote:
>> andymatei@gmail.com wrote:
>> > I have bought the Asus E45M1-M PRO to use in my home storage. [...]
>> > I get "Disabling IRQ 16" and "Disabling IRQ 19". [...]
>> > Is there a patch or something that resolves this issue yet?
>>
>> As far as I remember, this is a hardware bug in the ASMedia PCIe/PCI
>> bridge.  This can neither easily nor completely be worked around in
>> software.
>
> So, I got noted of this discussion: https://lkml.org/lkml/2012/1/30/216
>
> So why aren't you guys producing a proper patch for people to test?
> Simply get everyone of the bugreporters to give it a try and if all is
> well, Linus said he'll take it.
>
> Clemens, Jeroen?
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> GM: Alberto Bozzo
> Reg: Dornach, Landkreis Muenchen
> HRB Nr. 43632 WEEE Registernr: 129 19551
>



-- 
Andrei Matei
IT Manager @ Daromex SRL
0744 700 445
andrei@matei.ro
andymatei@gmail.com
