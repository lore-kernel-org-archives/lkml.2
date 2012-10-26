Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab2JZMz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:55:26 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47132 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab2JZMzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:55:22 -0400
Message-ID: <508A8825.8020502@free-electrons.com>
Date: Fri, 26 Oct 2012 14:55:01 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Cooper <jason@lakedaemon.net>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/4] Adding SATA support for Armada 370/XP
References: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com> <20121026123908.GH21046@lunn.ch>
In-Reply-To: <20121026123908.GH21046@lunn.ch>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 02:39 PM, Andrew Lunn wrote:
> On Fri, Oct 26, 2012 at 02:30:45PM +0200, Gregory CLEMENT wrote:
>> Hello,
>>
>> this patch set adds the SATA support for Armada 370 and Armada XP. Few
>> changes have been done since the first version by taking in account
>> the comments received for the first version.
>>
>> The evaluation boards for Armada 370 and Armada XP come with 2 SATA
>> ports, and when both are enable the coherent pool for DMA mapping was
>> too short. It was exactly the same issue that was fixed for Kirkwood
>> two months ago. So I used the same fix in the first patch. Later when
>> Kirkwood will be part of mach-mvebu, then this fix will be shared
>> between the 2 SoCs families.
>>
>> This patch set is based on 3.7-rc2 and depends one the framework clock
>> support (the last version was posted last week:
>> http://thread.gmane.org/gmane.linux.kernel/1375701). The git branch
>> called mvebu-SATA-for-3.8 is also available at
>> https://github.com/MISL-EBU-System-SW/mainline-public.git.
> 
> Hi Gregory
> 
> What about the openblocks-ax3?

Well I don't have this hardware, Thomas have. But with this question
I guess this board have (a) SATA port(s).

Moreover openblocks-ax3 is not (yet) in Jason branch so I can't make
a patch applying on a file which doesn't exist on my branch. It could
be a dependency but I try to reduce it as far as I can.

But as soon as this series will be applied, adding SATA support for
openblocks-ax3 should be pretty fast and just a matter of updating
the dts.

> 
>      Andrew
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
