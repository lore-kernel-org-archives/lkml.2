Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1A2JXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 04:23:39 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46207 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1A2JXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 04:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pj/bKBSNcnUqCdoiMR875ozHq5SHfUhKY2c0l0LTyQhquDsCV3VyEBSkziHjtbtM4t
         O23QkqTU5MFLgkLDGaLHi+liCC/NB9VsW4HoLyj+1t/iz3OQ1rHQvHebL6stkwGID6xg
         PPWStnrfALyEfRg9huFOrYgavJ8kEOmRC8VPQ=
Date: Sat, 29 Jan 2011 01:23:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Robin Theunis <robint91@gmail.com>
Cc: linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: USB HID plug and play, hardware developer frustration
Message-ID: <20110129092330.GF26915@core.coreip.homeip.net>
References: <AANLkTinytMpW8-7eEDg1O+vUP=C6-MHc8H8yssRbbxUc@mail.gmail.com>
 <20110129083638.GD26915@core.coreip.homeip.net>
 <AANLkTimq1JY5MNx3-CL=gfGreA5=VLtSfrg81TzftZd2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimq1JY5MNx3-CL=gfGreA5=VLtSfrg81TzftZd2@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 29, 2011 at 10:15:40AM +0100, Robin Theunis wrote:
> Hi Devs, Dmitry
> 
> Oh, there is some support for digitizers. That will help me a lot!
> Some thing else. When releasing my product how do I "ship" my driver?
> Or do I need to hope that it will be included in the kernel?
> 

If a new driver is indeed needed please take a look at
Documentation/SubmittingPatches and Documentation/SubmittingDrivers and
post it here and also CC Jiri Kosina who is HID maintainer.

And please do not top post.

Thanks.

-- 
Dmitry
