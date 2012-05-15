Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2EOL3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:29:08 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50908 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab2EOL3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:29:03 -0400
Message-ID: <4FB23DF8.8090508@mev.co.uk>
Date: Tue, 15 May 2012 12:28:56 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: refactor ni_pcimio driver and use module_comedi_pci_driver
References: <201205111651.56541.hartleys@visionengravers.com>
In-Reply-To: <201205111651.56541.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-12 00:51, H Hartley Sweeten wrote:
> +static struct comedi_driver ni_pcimio_driver = {
> +	.driver_name	= "ni_pcimio",

The original used the DRV_NAME macro expanding to "ni_pcimio" here...

> +static struct pci_driver ni_pcimio_pci_driver = {
> +	.name		= "ni_pcimio",

... which could also be used here.

(I realize this is a bit late as the patch is already committed!)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
