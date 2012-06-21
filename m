Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079Ab2FUJCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:02:05 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41530 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758989Ab2FUJBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:01:47 -0400
Message-ID: <4FE2E2F5.1000300@mev.co.uk>
Date: Thu, 21 Jun 2012 10:01:41 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: skel: use module_comedi_{pci_,}driver()
References: <201206201556.51336.hartleys@visionengravers.com> <20120620231230.GA28411@kroah.com> <ADE657CA350FB648AAC2C43247A983F0020698E77071@AUSP01VMBX24.collaborationhost.net> <20120620232331.GA25587@kroah.com> <ADE657CA350FB648AAC2C43247A983F0020698E7708B@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698E7708B@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-21 01:21, H Hartley Sweeten wrote:
> Question.
>
> Is there a way to do a 'git commit' with the diff generated using the
> "patience diff" algorithm?
>
> I have a patch that is really ugly when I do the git commit but looks
> ok if I do a 'git diff --patience'.

You can generate patches with the different diff algorithms, but I don't 
think it makes any difference to what gets committed in the git 
repository, or rather it doesn't make any difference when patches are 
sent upstream from that intermediate repository as the diff will be 
regenerated on the fly.

I guess your ugly patch is moving stuff around to avoid forward 
declarations?  Splitting it up into a number of steps seems to help in 
that case.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


