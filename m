Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1BUIfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:35:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64510 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1BUIfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DSeiZ+bJnD71KGPTuMWZrZHYHdO0nzmjex4Eas3qYdpJh0KnetkSmBXYPwLHsktEb1
         OKv5YY3aSHQxTlCCYcL+QAbunnEy2t/HApPeazBUV3MQNQ1m/PQ/Fig/4GU+HV3oz7di
         Eqtz+Ao9hPwM/IsxvTzpNzK9QOP/HD+7zwzAY=
Date: Mon, 21 Feb 2011 09:35:11 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/mm] x86-64, NUMA: Restructure initmem_init()
Message-ID: <20110221083511.GC31267@htj.dyndns.org>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org>
 <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 07:34:57PM -0800, David Rientjes wrote:
> This doesn't look very clean, I think it would be much better to extract 
> the iteration out to a function of its own which takes an init and scan 
> function as arguments and then deal only with numa_off, CONFIG_ACPI_NUMA, 
> and CONFIG_AMD_NUMA callers in initmem_init().  If that's done, it's clear 
> that the dummy implementation will never fail and so the BUG() in this 
> case is never possible (which is intended if all else fails).

I don't know.  Maybe.  Care to send a patch?

-- 
tejun
