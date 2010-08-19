Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab0HSF1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:27:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57364 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0HSF1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ecfzovM+IWxOcDJM6g3ntUQ9cf7TbAkg2qHXxDYKNw73kD60siWiDufmNe2zU3RpV2
         5edGaHBRTveVKlpZcZywFcnqDRJ1NS+R8OVZKK9mDbChZMBF4lYFMI4n8FMu5xDH/JEi
         1e9SVXbEJFrdfOwCR/QYo+Zm79Rkno9o7TyN0=
Date: Wed, 18 Aug 2010 22:26:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH] firmware_class: fix typo in error path
Message-ID: <20100819052655.GD5832@core.coreip.homeip.net>
References: <1282144518.5249.2.camel@jlt3.sipsolutions.net>
 <20100818154330.GA4000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818154330.GA4000@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 08:43:30AM -0700, Greg KH wrote:
> On Wed, Aug 18, 2010 at 05:15:18PM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > In the error path, _request_firmware sets
> > firmware_p to NULL rather than *firmware_p,
> > which leads to passing a freed firmware
> > struct to drivers when the firmware file
> > cannot be found. Fix this.
> > 
> > Broken by commit f8a4bd3456b988fc73b2c.
> 
> Nice catch, thanks.  I'll queue it up.
> 

Yep, looks good, thank you for fixing this,

-- 
Dmitry
