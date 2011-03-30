Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1C3XsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:48:07 -0400
Received: from void.printf.net ([89.145.121.20]:41053 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab1C3XsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:48:05 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj <manoj.iyer@canonical.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>
	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>
Date: Wed, 30 Mar 2011 19:53:58 -0400
In-Reply-To: <4D93BDA9.1020107@canonical.com> (Manoj's message of "Wed, 30 Mar
	2011 18:32:57 -0500")
Message-ID: <m3vcz02mi1.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 30 2011, Manoj wrote:
>>
>> * turn on CONFIG_MMC_DEBUG and post output
>> * see if sdhci.debug_quirks=1 helps
>
> It could be that this card does not support MMC cards, it shows up as
> SDHCI controller and does not mention MMC, or may be they all come up
> as SDHCI, I dont know enough to make that assessment.
>
> Here is the output with debug turned on. Sorry for the flood:

There's no sign of life at all from the card.  Have you tried another
MMC card to verify that this one isn't broken?  Or the quirks?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
