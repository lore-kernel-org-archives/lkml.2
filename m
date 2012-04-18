Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2DRIAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:00:49 -0400
Received: from antcom.de ([188.40.178.216]:57605 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab2DRIAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:00:48 -0400
Message-ID: <4F8E74AA.7030808@antcom.de>
Date: Wed, 18 Apr 2012 10:00:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 0/8] Second patchset for LPC32xx device tree conversion
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <20120417205001.GH6498@mwanda>
In-Reply-To: <20120417205001.GH6498@mwanda>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 10:50 PM, Dan Carpenter wrote:
> On Tue, Apr 17, 2012 at 07:08:19PM +0200, Roland Stigge wrote:
>> Applies to v3.4-rc3
>>
> 
> This probably applies fine (the previous version did a couple days
> ago), but it's always best to submit patches against linux-next.
> The 3.4 kernel is in -rc already so this is 3.5 material.

IIRC, I've been asked by Arnd to always build upon current rc tags.
(Sounded reasonable, since this one will become a stable release upon
which "my" patches will eventually be merged in the following merge window.)

Please point me to what I got wrong where, or try to agree on one
strategy here.

Thanks in advance,

Roland
