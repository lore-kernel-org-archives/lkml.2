Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab1CaQZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:25:25 -0400
Received: from void.printf.net ([89.145.121.20]:44232 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1CaQZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:25:14 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj <manoj.iyer@canonical.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>
	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>
	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>
	<m3sju3z6yc.fsf@pullcord.laptop.org> <4D949298.4000701@canonical.com>
	<m3oc4rz5kp.fsf@pullcord.laptop.org> <4D94A510.4040509@canonical.com>
Date: Thu, 31 Mar 2011 12:31:05 -0400
In-Reply-To: <4D94A510.4040509@canonical.com> (Manoj's message of "Thu, 31 Mar
	2011 11:00:16 -0500")
Message-ID: <m3fwq3z1yu.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 31 2011, Manoj wrote:
> Tried your patch, also enabled CONFIG_MMC_DEBUG=y
> CONFIG_MMC_RICOH_MMC=y, with the same result. MMC did not mount.

Okay, thanks for trying.

> Here is a portion of dmesg:

Please send all of dmesg; I want to see whether the Ricoh code ran.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
