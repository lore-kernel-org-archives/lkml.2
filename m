Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0INIAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:00:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48628 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0INIAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R0vDejl1zOGKI7pTRBJrEX5Sr1vjfYcwSILjVRmR8z/InOSdYDN7cNVk5k3w/glxOd
         mqLjTwvD9JVlR4HRPWfGXcWxeZmhgCnqXB9H8U5BveMP79g/gYRmKVvDshbHfxINS8lg
         jrPzpQobxBeFHRTCnRflErJ0rEXNzZw/9V05E=
Date: Tue, 14 Sep 2010 01:00:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Hemanth V <hemanthv@ti.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH V3 1/2] input: CMA3000 Accelerometer driver
Message-ID: <20100914080003.GD15167@core.coreip.homeip.net>
References: <61033.10.24.255.18.1283926671.squirrel@dbdmail.itg.ti.com>
 <4C877584.7000902@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C877584.7000902@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 12:37:40PM +0100, Jonathan Cameron wrote:
> 
> I'm happy to see your driver go in as it is currently, what bothers me is that we will end
> up with incompatible interfaces for all the accelerometers Dmitry takes!
> 

This is a valid concern. How about I chicken out and will not merge any
new sysfs knobs until you guys decide on reasonable interface? Most set
up is done by board code anyways, sysfs is more of nice-to-have?

-- 
Dmitry
