Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1BTV6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:58:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1BTV6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NDEloCxBaqfy1cpiQbN1kkNd2ptCQ1KoVSoU98f72BaVbiduDHRhEUOCATRuOhQa0e
         MN+hc9Ten8nAKp3hyyeg==
Date: Sun, 20 Feb 2011 13:58:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/3 tip:x86/mm] x86-64, NUMA: Move NUMA emulation into
 numa_emulation.c
In-Reply-To: <4D5EB35D.3000305@kernel.org>
Message-ID: <alpine.DEB.2.00.1102201357110.26991@chino.kir.corp.google.com>
References: <20110218135836.GG21209@htj.dyndns.org> <20110218135939.GH21209@htj.dyndns.org> <4D5EB35D.3000305@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Yinghai Lu wrote:

> David, can you please check tip/x86/mm ?
> 

Yeah, I'm in the process of doing so without this set yet.  I'm getting 
boot failures for numa=fake=128M right now, so I'll need to investigate 
and diagnose that issue before adding more patches.
