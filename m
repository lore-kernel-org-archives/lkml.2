Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1DLUCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:02:24 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:52271 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227Ab1DLUCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:02:22 -0400
Message-ID: <4DA4AFE6.8050007@metafoo.de>
Date: Tue, 12 Apr 2011 22:02:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Jassi Brar <jassi.brar@samsung.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [alsa-devel] [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario
 management code.
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>	<1299495878.3377.17.camel@odin> <20110307122520.GI13471@opensource.wolfsonmicro.com>
In-Reply-To: <20110307122520.GI13471@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 01:25 PM, Mark Brown wrote:
> On Mon, Mar 07, 2011 at 11:04:38AM +0000, Liam Girdwood wrote:
> 
>> Just had a quick look. All 
> 
>> Acked-by: Liam Girdwood <lrg@ti.com>
> 
> Applied 1-6 - I'll wait for Kukjin to check patch 7 just in case he
> wants it to go via his tree, there's no compile time dependency.

Thanks.

So far patch 7 (adding the dfbmcs320 platform device to gta02 mach file) hasn't
been applied. Should I resent it, or do you still have it?

- Lars
