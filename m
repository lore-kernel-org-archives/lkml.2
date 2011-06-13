Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1FMJdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:33:21 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:60244 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1FMJdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:33:18 -0400
Message-ID: <4DF5D959.2080602@mev.co.uk>
Date: Mon, 13 Jun 2011 10:33:13 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110526 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Staging: comedi: add dyna_pci10xx driver
References: <20110613072850.GA7289@mail.fossee.in>
In-Reply-To: <20110613072850.GA7289@mail.fossee.in>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/11 08:28, Prashant P. Shah wrote:
> For Dynalog PCI DAQ cards:
>   PCI-1050
> 
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
> ---
>  drivers/staging/comedi/drivers/dyna_pci10xx.c |  462 +++++++++++++++++++++++++
>  1 files changed, 462 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/comedi/drivers/dyna_pci10xx.c

It looks good to me!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
