Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1EEBxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 21:53:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40644 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1EEBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 21:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mieyXS2nTDX2tUmjEXInu5ugPW7EcoGd9GRSSABIdEqinJc8uQCMku4zWNZs8STudI
         r17L2hUoo0W5kVZQfVptSUImAz6Zx9joLIjZwMbXfjlB8OTpc21YByuvAl7fhrne2cfj
         u4lnrcYlgg1BjDy11rgwNFiQpTZ0GPi1J/ELo=
Date: Thu, 5 May 2011 09:53:08 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH-v6 1/2]KernelDoc:Add the device driver-model structures
 to kerneldoc
Message-ID: <20110505015303.GD2335@gmail.com>
Mail-Followup-To: Wanlong Gao <wanlong.gao@gmail.com>, greg@kroah.com,
	linux-kernel@vger.kernel.org
References: <1304553337-2485-1-git-send-email-wanlong.gao@gmail.com>
 <1304553337-2485-2-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304553337-2485-2-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 07:55:36AM +0800, Wanlong Gao wrote:

> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> 
> 
> 
> Add the comments to the structure bus_type, device_driver, device,
> class to device.h for generating the driver-model kerneldoc. With another patch
> these all removed from the files in Documentation/driver-model/ since
> they are out of date. That will keep things up to date and provide a better way
> to document this stuff.
>  
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
