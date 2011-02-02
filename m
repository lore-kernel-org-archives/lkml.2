Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1BBEpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 23:45:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60466 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab1BBEpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 23:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D2BBIOUI5o1g1fUb2z+mrHxgUYIHs9Od3Urs2nBwGQczUUCd5xIiqCEj1KK1HJXCbT
         ymtuuETGQoUK70qRa2GQXn6DK72nDA4wQQJrs+EOxdNPM0+ofKEd0/AdpaMkySI4o8Y6
         LFLKocqiE4L2tjPN7JxYnq1W7ocIqOxEWtXV0=
Date: Tue, 1 Feb 2011 20:45:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Chou <thomas@wytron.com.tw>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Subject: Re: [PATCH v2] altera_ps2: Add devicetree support
Message-ID: <20110202044503.GA19533@core.coreip.homeip.net>
References: <20110117220415.GB17963@angua.secretlab.ca>
 <1295848693-28472-1-git-send-email-thomas@wytron.com.tw>
 <20110202043121.GF29148@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202043121.GF29148@angua.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 09:31:21PM -0700, Grant Likely wrote:
> On Mon, Jan 24, 2011 at 01:58:13PM +0800, Thomas Chou wrote:
> > @@ -182,6 +189,7 @@ static struct platform_driver altera_ps2_driver = {
> >  	.driver	= {
> >  		.name	= DRV_NAME,
> >  		.owner	= THIS_MODULE,
> > +		.of_match_table = altera_ps2_match,
> 
> At the moment, this patch can only be applied against my
> devicetree/next branch since there is a #ifdef CONFIG_OF around
> of_match_table in mainline, and the patch to remove it is in my next
> branch.  I'm okay with taking it through my tree if Dmitry agrees.
> 

Actually I was going to ask you if you could do just that.

Thanks.

-- 
Dmitry
