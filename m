Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1AXVx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:53:57 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47862 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab1AXVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:53:55 -0500
From: Kevin Hilman <khilman@ti.com>
To: Govindraj <govindraj.ti@gmail.com>
Cc: Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        manjugk@ti.com, gadiyar@ti.com, tony@atomide.com, govindraj@ti.com,
        gregkh@suse.de, andrei.emeltchenko@nokia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] OMAP: Enable Magic SysRq on serial console ttyOx
Organization: Texas Instruments, Inc.
References: <1295604084-27761-1-git-send-email-weber@corscience.de>
	<AANLkTikSznkcNwkVaPswx=zr8FFGQPVMw_AebF9ymZLE@mail.gmail.com>
Date: Mon, 24 Jan 2011 13:47:21 -0800
In-Reply-To: <AANLkTikSznkcNwkVaPswx=zr8FFGQPVMw_AebF9ymZLE@mail.gmail.com>
	(Govindraj's message of "Fri, 21 Jan 2011 15:42:57 +0530")
Message-ID: <8739oi7z4m.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Govindraj <govindraj.ti@gmail.com> writes:

> On Fri, Jan 21, 2011 at 3:31 PM, Thomas Weber <weber@corscience.de> wrote:
>> Magic SysRq key is not working for OMAP on new serial
>> console ttyOx because SUPPORT_SYSRQ is not defined
>> for omap-serial.
>>
>> This patch defines SUPPORT_SYSRQ in omap-serial and
>> enables handling of Magic SysRq character.
>>
>> Further there is an issue of losing first break character.
>> Removing the reset of the lsr_break_flag fixes this issue.
>>
>> Signed-off-by: Thomas Weber <weber@corscience.de>
>
>
> Acked-by: Govindraj.R <govindraj.raja@ti.com>
> Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
>

Acked-by: Kevin Hilman <khilman@ti.com>

Greg, this one should go for .38-rc.   Feel free to merge, or we can
take it through the OMAP tree with your ack.

Thanks,

Kevin

