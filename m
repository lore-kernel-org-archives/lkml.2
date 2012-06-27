Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2F0Jel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:34:41 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34202 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab2F0Jei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:34:38 -0400
Message-ID: <4FEAD3A9.9020605@mev.co.uk>
Date: Wed, 27 Jun 2012 10:34:33 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 28/36] staging: comedi: cb_pcidas: remove 'volatile' on
 private data variables
References: <201206261806.52836.hartleys@visionengravers.com>
In-Reply-To: <201206261806.52836.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-27 02:06, H Hartley Sweeten wrote:
> As indicated by checkpatch.pl, "WARNING: Use of volatile is usually
> wrong: ...". The variables in the private data that are marked
> volatile don't need to be. Remove the volatile.

Yes, looks good!

Reviewed-by: Ian Abbott <abbbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


