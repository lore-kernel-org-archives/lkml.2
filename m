Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1BTED7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:03:59 -0500
Received: from smtp-out.google.com ([216.239.44.51]:31050 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1BTEDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:03:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JItxqr2Y/tgISjNxNod8SOMZDjM7UC6mX31bvBWMwwMKOE6+NRi30VfEMtgcirlGDM
         fSMg/jgTGp+BXDa6tA6w==
Date: Sat, 19 Feb 2011 20:03:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 4/4] x86, numa: seperate alloc_numa_distance from
 numa_reset_distance.
In-Reply-To: <4D5EC19A.9030808@kernel.org>
Message-ID: <alpine.DEB.2.00.1102192002480.32699@chino.kir.corp.google.com>
References: <4D5EC05A.60103@kernel.org> <4D5EC19A.9030808@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Yinghai Lu wrote:

> 
> alloc code is much bigger the setting self.
> 
>  make the code some readable.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
