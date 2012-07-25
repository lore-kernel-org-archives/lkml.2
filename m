Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2GYJw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:52:26 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:52134 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2GYJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:52:24 -0400
Message-ID: <500FC1D3.3090401@ahsoftware.de>
Date: Wed, 25 Jul 2012 11:52:19 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make IKCONFIG an embedded option, enabled by default
References: <1343188416-7742-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1343188416-7742-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.07.2012 05:53, schrieb Alexander Holler:
> Knowing (being sure) which configuration was used to build a (maybe running)
> kernel is important for many scenarios.
>
> It's usually much more important than saving a few kb in the size of
> the kernel. Therefor turn on CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC
> by default and make them visible only when CONFIG_EMBEDDED is enabled,
> preventing premature optimization.
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

If that patch gets accepted, a patch which removes CONFIG_IKCONFIG and 
CONFIG_IKCONFIG_PROC from about 160 defconfigs would be possible too.

I'm not sure if one patch which removes them all at once would be 
accepted. But if the above patch would be accepted, I'm willing to post 
such a patch too.

Regards,

Alexander
