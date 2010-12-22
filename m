Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab0LVUOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:14:41 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:38534 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751193Ab0LVUOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:14:40 -0500
Date: Wed, 22 Dec 2010 21:14:10 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Stano =?utf-8?B?TGFuxI1p?= <chl.pixo@gmail.com>
Cc: Belisko Marek <marek.belisko@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: ft1000-pcmcia: Fix compilation errors.
Message-ID: <20101222201410.GA14419@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Stano =?utf-8?B?TGFuxI1p?= <chl.pixo@gmail.com>,
	Belisko Marek <marek.belisko@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1292573592-3624-1-git-send-email-marek.belisko@open-nandra.com>
 <1292573592-3624-2-git-send-email-marek.belisko@open-nandra.com>
 <20101217130426.GA21706@isilmar-3.linta.de>
 <AANLkTimivmbhJed8_x_MGWem-3p2EBHj7H--qUy+oSQP@mail.gmail.com>
 <AANLkTinD0f06h75dP9b9d8k3jZ2jbaYX2u=tRS4UWZbc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinD0f06h75dP9b9d8k3jZ2jbaYX2u=tRS4UWZbc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Dec 22, 2010 at 05:14:14PM +0100, Stano Lanči wrote:
> I reviewed your suggestion to use pcmcia_get_mac_from_cis().
> The problem is we need net_device structure and we create it
> in init_ft1000_card() that needs the mac address as one input parameter.
> I can move the code for it to ft1000_hw.c that deals with network part of
> the code, but then if the pcmcia API change that file will also
> have to be reviewed.

If it isn't too much of a hassle to update ft1000_hw.c, I'd prefer that
approach, for I do not intend to change the pcmcia API in this regard. And
if I do, I'll feel responsible for fixing ft1000 as well :)

Best,
	Dominik
