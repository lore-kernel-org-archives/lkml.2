Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0FNQTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:19:20 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:35191 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0FNQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:19:19 -0400
Message-ID: <4C165684.1060609@pardus.org.tr>
Date: Mon, 14 Jun 2010 19:19:16 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: video: DMI workaround broken Acer 5710 BIOS	enabling
 display brightness
References: <1276499864-7609-1-git-send-email-ozan@pardus.org.tr> <20100614142554.GA22158@srcf.ucam.org>
In-Reply-To: <20100614142554.GA22158@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Jun 14, 2010 at 10:17:44AM +0300, Ozan Çağlayan wrote:
>> Acer Aspire 5710 suffers from a similar ACPI problem reported at:
>>  http://bugzilla.kernel.org/show_bug.cgi?id=13121
> 
> Bleah. Is this really necessary? If we set maximum brightness and then 
> read back something other than maximum brightness, then that gives us 
> the offset.

By *this* do you mean the specific quirk that I sent or the whole offset workaround
suggested and upstreamed in the bug report?

Actually I sync'ed the video driver from linux-2.6 on top of 2.6.31.13 and applied this patch.
The user reported that it fixed the issue but it is possible that this quirk
is NOOP and the bug is already fixed with what I've backported.

I'll let him try without the patch, and report back.

Thanks,
Regards.
