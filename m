Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2F0JUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:20:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34140 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab2F0JUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:20:47 -0400
Message-ID: <4FEAD06A.2030302@mev.co.uk>
Date: Wed, 27 Jun 2012 10:20:42 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 16/36] staging: comedi: cb_pcidas: simplify the boardinfo
References: <201206261756.44046.hartleys@visionengravers.com>
In-Reply-To: <201206261756.44046.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-27 01:56, H Hartley Sweeten wrote:
> The boardinfo values 'has_ai_trig_gated' and 'has_ai_trig_invert'
> are both only set for the "1602" versions of the boards supported
> by this driver.
>
> Simplify the boardinfo, and the code, by replacing these two
> variables with one "is_1602" variable.

This doesn't save any code and would make it harder to add a board that 
would need 'has_ai_trig_gated' and 'has_ai_trig_invert' set to different 
values (although it's pretty unlikely that new such boards would be 
added to this driver).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


