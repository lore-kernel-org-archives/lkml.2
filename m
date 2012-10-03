Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2JCBEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 21:04:20 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64776 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2JCBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 21:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121002053223.GA20786@ioremap.net>
References: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
	<5069D830.6070307@freescale.com>
	<20121002053223.GA20786@ioremap.net>
Date: Tue, 2 Oct 2012 22:04:19 -0300
Message-ID: <CAOMZO5Aun8OMKY0wPm9TZfyqWwCNGa7xvWyR7W-bzwG_=1iecQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] w1: mxc_w1: Adapt the clock name to the new clock framework
From: Fabio Estevam <festevam@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha,

On Tue, Oct 2, 2012 at 2:32 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Mon, Oct 01, 2012 at 02:51:44PM -0300, Fabio Estevam (fabio.estevam@freescale.com) wrote:
>> Evgeny,
>>
>> Any comments, please?
>
> I have no objections per se, but I'm hardly an expert in imx clock
> framework :)
>
> Since it is only one patch in set of 3, I suppose it will be pushed
> through different tree than w1. Feel free to add my ack.
>
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Could this series go via your tree?

Regards,

Fabio Estevam
