Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1CBU5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:57:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60322 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab1CBU5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uCNbW9rxsdxlJzsx6NSrNHP05gkU2cYuCa270bk2xXlFcw9NXdF2yZuEajID73hMeJ
         gGKJ1Ghui1qPJKYdH9U73/T/SdHBa1zv2+yB2j9idTGlGRVEEUCPfzQqPvjJ4gfDUuUw
         9JHQCCY8ceaAQdlBRShYecwAACRw+9dBEqQrE=
Date: Wed, 2 Mar 2011 21:57:04 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110302205704.GF28266@mtj.dyndns.org>
References: <20110302102530.GB3319@htj.dyndns.org>
 <4D6E6D52.8030901@kernel.org>
 <20110302163729.GQ3319@htj.dyndns.org>
 <4D6E7459.6050706@kernel.org>
 <20110302165545.GR3319@htj.dyndns.org>
 <4D6E91EC.6040906@kernel.org>
 <20110302190208.GD28266@mtj.dyndns.org>
 <4D6E9541.2040201@kernel.org>
 <20110302191338.GE28266@mtj.dyndns.org>
 <4D6EA975.8070200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EA975.8070200@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:32:53PM -0800, Yinghai Lu wrote:
> why use enabled nodes?
> 
> numa_alloc_distance already have calculated. with numa_nodes_parsed and numa_meminfo

Because it's simpler that way.

-- 
tejun
