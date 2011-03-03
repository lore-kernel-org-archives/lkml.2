Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1CCGRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:17:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52926 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1CCGRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZT5k4sS8FAYh4nc6/ZoRQc0vfAk5/CEyF11PKFzQApUTis0voXjdrkqfkuJb6c1RgW
         eA22rZzZheLJ+jfxofKlxSCwv+Otr+axt1G0bRbcNK/ERclA7yJYwVLu1vHLos1nW6NW
         XoMs8zlOFVPkN6GPAhauasbjN3nSntBk1r+ic=
Date: Thu, 3 Mar 2011 07:17:11 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110303061711.GG28266@mtj.dyndns.org>
References: <20110302163729.GQ3319@htj.dyndns.org>
 <4D6E7459.6050706@kernel.org>
 <20110302165545.GR3319@htj.dyndns.org>
 <4D6E91EC.6040906@kernel.org>
 <20110302190208.GD28266@mtj.dyndns.org>
 <4D6E9541.2040201@kernel.org>
 <20110302191338.GE28266@mtj.dyndns.org>
 <4D6EA975.8070200@kernel.org>
 <20110302205704.GF28266@mtj.dyndns.org>
 <4D6EB335.8000306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EB335.8000306@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 01:14:29PM -0800, Yinghai Lu wrote:
> what do you mean "enabled nodes"? numa_nodes_parsed? or from new
> numa_meminfo?

Yeah.

-- 
tejun
