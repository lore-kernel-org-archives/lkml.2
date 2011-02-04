Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1BDLEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 06:04:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44306 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1BDLEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 06:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YBo2ZMDkUCjKxUaoQRAJO6MQRbHKd4g8jW4SLT7Ys8fVnPOKZi2gg9RRr0i1ZZzvNG
         zeOIpvEvxzAwboadOau13Fn7ByhCnNnbfCNhDvt6G0QRIcguhmC74MvYLfGZdWoo7UXI
         jEI4/Qg3p0I/VA9qEZO7pFaU92dJEHa+1OPiM=
Date: Fri, 4 Feb 2011 12:03:32 +0100
From: Tejun Heo <tj@kernel.org>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH UPDATED 08/32] drm/nouveau: use system_wq instead of
 dev_priv->wq
Message-ID: <20110204110332.GC12133@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-9-git-send-email-tj@kernel.org>
 <1294189627.2276.0.camel@nisroch>
 <1294190172.2276.2.camel@nisroch>
 <20110106172922.GA29580@mtj.dyndns.org>
 <20110126164918.GQ12520@htj.dyndns.org>
 <20110201104135.GI14211@htj.dyndns.org>
 <1296784411.7970.1.camel@nisroch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296784411.7970.1.camel@nisroch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 04, 2011 at 11:53:25AM +1000, Ben Skeggs wrote:
> Thanks for this again.  I've just made some changes to the nv50 display
> bottom half handling that these will conflict with, they'll hit the
> nouveau tree next week.

Eh, so it doesn't apply again?  :-)

> I'll push the still-relevant bits of your nouveau patch through the
> nouveau tree for the 2.6.39-rc1 merge window.  That ok?

Yeah, sure, but if you tell me against which tree I should generate
patch, I can also just redo the patch.

Thanks.

-- 
tejun
