Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1ASNcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 08:32:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab1ASNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 08:32:00 -0500
Message-ID: <4D36E7CC.5090303@corscience.de>
Date: Wed, 19 Jan 2011 14:31:56 +0100
From: Thomas Weber <weber@corscience.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101220 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
CC: Govindraj <govindraj.ti@gmail.com>, Thomas Weber <weber@corscience.de>,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
References: <1295426461-12459-1-git-send-email-weber@corscience.de> <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com> <20110119130049.GB9365@m-desktop>
In-Reply-To: <20110119130049.GB9365@m-desktop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:/CvO4h1nupRvl+miNuTbawKzG5c5x96+KWCZOHUg5qU
 H2paHGoUDZB/8wE+6Pdj7HCGpaZ4G3VCgj6gvj8Ey+/mhucGyN
 UwIsBwzWdv+HQWn0LZJzCStZ+BE2Khz4Pno46QYsEgVpNQ2SJs
 n7Kdu8kf29ZmSY/EaaQsgLg6fEuGCZTQRec+i08u/Ddyyca/qV
 dNaOwHHe7BEVXio5wLQXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.01.2011 14:00, schrieb G, Manjunath Kondaiah:
> On Wed, Jan 19, 2011 at 03:01:39PM +0530, Govindraj wrote:
>> On Wed, Jan 19, 2011 at 2:11 PM, Thomas Weber <weber@corscience.de> wrote:
>>> Magic SysRq key is not working for OMAP on new serial
>>> console ttyOx because SUPPORT_SYSRQ is not defined
>>> for omap-serial.
>>>
>>> This patch defines SUPPORT_SYSRQ in omap-serial and
>>> enables handling of Magic SysRq character.
>>>
>>> Signed-off-by: Thomas Weber <weber@corscience.de>
>>
>> Looks fine to me.
>>
>> Acked-by: Govindraj.R <govindraj.raja@ti.com>
> I tried to use SysRq key on minicom after applying this patch, it looks
> like it is not triggering sysrq event.
> 
> Am I missing anything?
> 
> -Manjunath
> --
Hello Manjunath,

Do you have CONFIG_MAGIC_SYSRQ enabled?
Magic SysRq key in Kernel Hacking

I tested it on Devkit8000 (beagle board clone).

Thomas
