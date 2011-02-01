Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1BAXKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 18:10:45 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52645 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab1BAXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 18:10:44 -0500
From: Kevin Hilman <khilman@ti.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-omap@vger.kernel.org, "Govindraj.R" <govindraj.raja@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        Thomas Weber <weber@corscience.de>
Subject: Re: [PATCHv4] OMAP: Enable Magic SysRq on serial console ttyOx
Organization: Texas Instruments, Inc.
References: <1296545441-17070-1-git-send-email-weber@corscience.de>
	<87ei7ryavx.fsf@ti.com> <20110201222342.GA19137@suse.de>
Date: Tue, 01 Feb 2011 15:10:40 -0800
In-Reply-To: <20110201222342.GA19137@suse.de> (Greg KH's message of "Tue, 1
	Feb 2011 14:23:42 -0800")
Message-ID: <87oc6vnyfj.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, Feb 01, 2011 at 08:31:30AM -0800, Kevin Hilman wrote:
>> Thomas Weber <weber@corscience.de> writes:
>> 
>> > Magic SysRq key is not working for OMAP on new serial
>> > console ttyOx because SUPPORT_SYSRQ is not defined
>> > for omap-serial.
>> >
>> > This patch defines SUPPORT_SYSRQ in omap-serial and
>> > enables handling of Magic SysRq character.
>> >
>> > Further there is an issue of losing first break character.
>> > Removing the reset of the lsr_break_flag fixes this issue.
>> >
>> > Signed-off-by: Thomas Weber <weber@corscience.de>
>> > Acked-by: Govindraj.R <govindraj.raja@ti.com>
>> > Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
>> > Acked-by: Kevin Hilman <khilman@ti.com>
>> 
>> Greg,
>> 
>> Will you be taking this?  If you prefer, we can take it via OMAP tree
>> with your ack.
>
> I can take it if it's not a problem for you.  Or if you want to, please
> add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patch.
>
> Let me know which is easier for you.

Since there are no dependencies on arch/arm/*omap*, you can merge it.

Thanks,

Kevin
