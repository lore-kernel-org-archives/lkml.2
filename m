Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2FHGpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:45:14 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:42525 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab2FHGpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:45:12 -0400
Message-ID: <4FD19FBB.4040507@mev.co.uk>
Date: Fri, 8 Jun 2012 07:46:19 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: serial2002: quiet NULL pointer sparse
 noise
References: <201206071714.25934.hartleys@visionengravers.com>
In-Reply-To: <201206071714.25934.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/12 01:14, H Hartley Sweeten wrote:
> Quiet a number of sparse warnings in this file:
>
> warning: Using plain integer as NULL pointer

I wonder why sparse warns about that for a literal, unadorned 0?  I 
suppose NULL is more explicit, but a plain 0 means the same as NULL in a 
pointer context (unlike a zero from some random expression).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
