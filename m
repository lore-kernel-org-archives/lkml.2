Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1BPWoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:44:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1BPWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:44:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o4YYGWdJA0jgRkyvYhxWWmV5VxBeOeApSkueKH/zzUlfrnvy5JIlQ8GVUnOOoLDes6
         hGjTt24E1V2J10kzdqrjZebpefw+65/+DclIxlb8pnw3E2hwewmPMpJzn331GzDdz3Tu
         vquHV5w0QE/5TDQqIW47L2MqaPzEPYO82AegY=
Date: Wed, 16 Feb 2011 23:44:16 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86, numa: put dummy_numa_init in init section
Message-ID: <20110216224416.GC29600@atj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
 <4D5C501E.50805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C501E.50805@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 02:30:54PM -0800, Yinghai Lu wrote:
> 
> like other __numa_init
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

--
tejun
