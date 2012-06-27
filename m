Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab2F0RCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:02:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34917 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab2F0RCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:02:41 -0400
Message-ID: <4FEB3CAA.3060300@mev.co.uk>
Date: Wed, 27 Jun 2012 18:02:34 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: "sclark46@earthlink.net" <sclark46@earthlink.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/36] staging: comedi: cb_pcidas: cleanup the driver
References: <201206261745.00636.hartleys@visionengravers.com> <4FEB3553.8050609@earthlink.net> <ADE657CA350FB648AAC2C43247A983F0020698F2E703@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698F2E703@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-27 17:45, H Hartley Sweeten wrote:
> On Wednesday, June 27, 2012 9:31 AM, Stephen Clark wrote:
>> I there some reason you can't post these as response to this message,
>> like GKH does, so if readers aren't
>> interested they can mark the thread read without stepping thru each patch.
>
> The only reason is, I'm not sure how to do that... ;-)
>
> Greg, any pointers on how?

The easiest way is to use the --compose option of git send-email, which 
lets you edit an introductory email to the patch series you are posting 
and uses that email's ID as the --in-reply-to for all the following 
patch emails (assuming you don't have --chain-reply-to set).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


