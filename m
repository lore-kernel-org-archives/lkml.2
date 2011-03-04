Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1CDVw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:52:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47455 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760279Ab1CDVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h98dBC0tOkMLH0/DpRH3KHC75Pzcf94/OJgCDuBB8n1Ru8yrkTmobtZnaQkIV8pJKY
         ZPr/XMx/sq5pd0MTxTTAVuwXKNMrHMqCpU+L1LYj4r9jIO0HqQ6BRcIVLuco56WUx5ik
         p2DxaUJ30uaINeRWhrgGFRYGysbHucFICwGg4=
Date: Sat, 5 Mar 2011 00:52:20 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
Message-ID: <20110304215218.GB30253@albatros>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
 <20110304203201.GA22079@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304203201.GA22079@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 21:32 +0100, Pavel Machek wrote:
> > +	if (modules_disabled)
> > +		return -EPERM;
> > +
> >  	error = platform_begin(platform_mode);
> 
> Hmm. How is this supposed to work with CONFIG_MODULES off?

Good catch, thank you.  I'll fix this.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
