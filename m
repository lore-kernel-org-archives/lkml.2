Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0LOQZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:25:49 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:40232 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0LOQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:25:47 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Zhang Lily-R58066 <r58066@freescale.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] ARM i.MX51: Add IPU device support
Organization: RtpNet
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
	<1291902441-24712-7-git-send-email-s.hauer@pengutronix.de>
	<201012151649.45199.arnd@arndb.de>
Date: Wed, 15 Dec 2010 17:26:20 +0100
In-Reply-To: <201012151649.45199.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 15 Dec 2010 16:49:45 +0100")
Message-ID: <87pqt3c89f.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

Hi,

> On Thursday 09 December 2010, Sascha Hauer wrote:
>> +#define imx51_add_ipuv3(pdata) \
>> +       imx_add_ipuv3(&imx51_ipuv3_data, pdata)
>
> This looks  like a pointless abstraction, it does not make
> the code smaller or easier to read. I know it's sometimes
> tempting to use macros, but in most cases, you should try
> not to.
>

it's how things have been handled atm in the imx code. I don't have
any preference on this at all but at least either we go on with it 
or we get rid of all theses #defines. It's a matter of consistency.
The thing is that I would consider removing the imx*add* stuff to be
a cleanup and should be done in a different patch, not in a patchset
adding IPU support for imx51.

Anyway, let's wait for Sascha's point of view, he knows the imx stuff
far better than me.

Arnaud
