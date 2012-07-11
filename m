Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2GKKdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:33:19 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51585 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab2GKKdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:33:14 -0400
Message-ID: <4FFD5665.7040901@mev.co.uk>
Date: Wed, 11 Jul 2012 11:33:09 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: Ian Abbott <ian.abbott@mev.co.uk>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/83] staging: comedi: rtd520: initial cleanup
References: <201207101636.23561.hartleys@visionengravers.com> <4FFD536B.8010603@mev.co.uk>
In-Reply-To: <4FFD536B.8010603@mev.co.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-11 11:20, Ian Abbott wrote:
> On 2012-07-11 00:36, H Hartley Sweeten wrote:
> My main concern with this series of patches is they make it harder to
> determine what the register accesses actually do, mainly due to the
> removal of useful comments.  For example:
>
> -	RtdPacerStart(dev);	/* Start PACER */
> +	readl(devpriv->las0 + LAS0_PACER);
>
> And:
>
> -	RtdPacerStop(dev);	/* Stop PACER */
> +	writel(0, devpriv->las0 + LAS0_PACER);

It would be too much work to redo all those patches though.  I'll just 
make a patch to add back in the useful-looking comments.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


