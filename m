Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0HBUhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:37:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45185 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab0HBUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gb+ucbG8iQjfnHldOKmEe5CWSNUGL2NluGnQZbqDtKkEFlZEwh1M9f3wB0Fu3OXwWW
         pz9UfbneT43uEBtZsTXiUpX5DK12rStq2fLJICs4RPD09An63oCHN1X1m+FMnVNn4Qud
         MQTI4plkrPctu2R/vqnlxLzT+sJ+sSPIWVaXY=
Date: Tue, 3 Aug 2010 00:36:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
Message-ID: <20100802203659.GH5544@lenovo>
References: <4C56701B.1030000@kernel.org> <20100802150958.GA5544@lenovo> <4C571B25.3080806@kernel.org> <20100802201750.GG5544@lenovo> <4C572AD9.5070500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C572AD9.5070500@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 01:30:17PM -0700, Yinghai Lu wrote:
...
> >> +	/* make sure if it is copied already */
> >> +	if (boot_params.hdr.version)
> >> +		return;
> >> +
> > 
> > And Yinghai, lets be more verbose here a bit, since for those who will
> > be reading this code later might be non-obvious why we have checked for
> > 'version' here. I guess something like "an easy way to check if boot_params
> > were already copied". Actually it's clean from commit message but I think
> > we first read code comments and commit messages after, agreed? ;-)
> 
> will change to 
> 
>         /*
>          * hdr.version is always not 0, so check it to see
>          *  if boot_params is copied or not.
>          */
> 
> will resend this patch after memblock x86 changes.
> 
> YH
> 

ok, thanks!

	-- Cyrill
