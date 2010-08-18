Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0HROMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:12:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54894 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0HROMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tm2JtRhDbeYZXySgD/KRpuLSBKkN8MRE0dq2GdmgXPAYzbyV/jqW/cmLbga46S3aaP
         QiGhWdxqdyeow5fntCNH9Ol0wewoBUWRdftlDwZ5T84otHZ5zGMpZe/BJ1dEVRleku3K
         G8jiKb0yLkUv1KY22DUAX+b9kWykF3j/39XP4=
Date: Wed, 18 Aug 2010 16:03:35 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.2 regression, does not boot, sleeping function called
	from invalid context
Message-ID: <20100818140335.GB18303@linux-m68k.org>
References: <20100817145305.GA7342@linux-m68k.org> <20100818133459.GA6663@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818133459.GA6663@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 06:34:59AM -0700, Greg KH wrote:

> Does .35.1 work?

never tried but can give it a try tonight
> .35.2 has some issues that are being worked on, the patches to solve the
> bug is already in Linus's tree, give me a few days to get a new release
> out with this solved.

thanks, can I find the new patches in git somewhere?

Richard
