Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1FVGt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:49:59 -0400
Received: from lebrac.rtp-net.org ([88.191.135.105]:51702 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1FVGt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:49:58 -0400
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv7] ARM: mx51: Add support for low power suspend on MX51
Organization: RtpNet
References: <1301325297-24126-1-git-send-email-Dinh.Nguyen@freescale.com>
	<87k4cfa550.fsf@lebrac.rtp-net.org>
	<20110621223527.GF6069@pengutronix.de>
Date: Wed, 22 Jun 2011 08:49:42 +0200
In-Reply-To: <20110621223527.GF6069@pengutronix.de> (Sascha Hauer's message of
	"Wed, 22 Jun 2011 00:35:27 +0200")
Message-ID: <874o3i9x89.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:
Hi,

> On Tue, Jun 21, 2011 at 11:46:35AM +0200, Arnaud Patard wrote:
>> <Dinh.Nguyen@freescale.com> writes:
>> 
>> Hi,
>> 
>> > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> >
>> > Adds initial low power suspend functionality to MX51.
>> > Supports "mem" and "standby" modes.
>> >
>> > Tested on mx51-babbage.
>> >
>> > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> 
>> I fail to see this patch in imx tree. Did it get merged in some other
>> tree ?
>
> Not yet. Have you tested this patch?
>
Yes, it works fine on my platforms.

Arnaud
