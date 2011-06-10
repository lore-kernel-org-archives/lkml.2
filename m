Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab1FJR6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:58:07 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33180 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247Ab1FJR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:58:04 -0400
Message-ID: <4DF25AF5.6070909@metafoo.de>
Date: Fri, 10 Jun 2011 19:57:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, uclinux-dist-devel@blackfin.uclinux.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [Device-drivers-devel] [PATCH 1/3] ASoC: Add ADAU1701 codec driver
References: <1307726331-28618-1-git-send-email-lars@metafoo.de> <BANLkTimLAfEj+tgNMWjTsanccgfEt9UW1g@mail.gmail.com>
In-Reply-To: <BANLkTimLAfEj+tgNMWjTsanccgfEt9UW1g@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 07:43 PM, Mike Frysinger wrote:
> On Fri, Jun 10, 2011 at 13:18, Lars-Peter Clausen wrote:
>> +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
> 
> did you actually rewrite this thing from scratch ?  seems like you
> should keep Cliff as the author in git/MODULE_AUTHOR, and then add
> your name to the s-o-b list and this macro.

Not from scratch, but I guess except for the register definitions and the
copyright header not much of the original driver is left:
sound/soc/codecs/adau1701.c |  662 ++++++++++++++++++++++++-------------------
 1 files changed, 371 insertions(+), 291 deletions(-)



> 
> friendly git commits can easily be cherry picked from my tree for asoc stuff:
> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=summary
> (see the "trunk" branch)
> -mike

