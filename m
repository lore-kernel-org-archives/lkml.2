Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1CBTNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:13:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52975 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab1CBTNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U3ITsFU7p3TfaRAMkZyoEbNESnsEkRKjxg3xGfgUO4GQmSGMTbuMjxrwAswSm0ZE2+
         3mqimvL+IfQrhZr0t+uSZ8xor71lvcGcg/3kw/Ntx9ouG32BTmVs06G3Ws6Huoyhr1Sx
         roXTDxd4JAhTwo8gO9ArMbXfVOVtNzJaAM3WA=
Date: Wed, 2 Mar 2011 20:13:38 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110302191338.GE28266@mtj.dyndns.org>
References: <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <4D6E6D52.8030901@kernel.org>
 <20110302163729.GQ3319@htj.dyndns.org>
 <4D6E7459.6050706@kernel.org>
 <20110302165545.GR3319@htj.dyndns.org>
 <4D6E91EC.6040906@kernel.org>
 <20110302190208.GD28266@mtj.dyndns.org>
 <4D6E9541.2040201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E9541.2040201@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 02, 2011 at 11:06:41AM -0800, Yinghai Lu wrote:
> > Hmmm?  I can't really follow your sentence.  This is init stage.
> > Anyways, why can't it just walk over the enabled nodes?  What would be
> > the difference?
> 
> my point is that we really not need to go over it if original is not there.

Oh, you mean if (!phys_dist)?  Yeah yeah sure, I was mostly talking
about allocating new table separately and returning the count and all
those things.  Can you just do the phys_dist testing and going over
enabled nodes?

Thanks.

-- 
tejun
