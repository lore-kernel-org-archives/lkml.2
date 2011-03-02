Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab1CBSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:25:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44762 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1CBSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OVDYNSn1qAIMUfWHDUyexjmBsPgE9wff2htggoCk6SZoTaHLC7yCTbJO9oZnRWcP1/
         LJAzo4bWEzF85ypy7o1H48poWbVUWX6cv8e2tjhG5yxzQILpIIZRUmS3Otql8NrwrES6
         OKg/C7b0MQblPqO1Et2M7aMCCl7CsfUkfkEnM=
Date: Wed, 2 Mar 2011 19:25:51 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110302182551.GB28266@mtj.dyndns.org>
References: <20110226143730.GA26864@htj.dyndns.org>
 <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
 <20110302161900.GP3319@htj.dyndns.org>
 <AANLkTi=SYRK+iKT-Zwuyv=e6dLqmoL4cUts2Xoyq-M=1@mail.gmail.com>
 <20110302170702.GS3319@htj.dyndns.org>
 <20110302180827.GA13693@elte.hu>
 <4D6E8874.6070000@zytor.com>
 <20110302181941.GD13693@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302181941.GD13693@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 07:19:41PM +0100, Ingo Molnar wrote:
> Hm, i thought the revert was for tip:x86/mm, not x86/urgent. The development window 
> for 2.6.39 is closing down.
> 
> A revert (without an actual bug that it fixes) for -rc8 is definitely out of 
> question.

It is for x86/mm and it does address the unnecessarily smaller mapping
problem, which Yinghai's further patches address too.  Those patches
are what triggered me to ask for a revert because they kinda show how
ugly the underlying code is and add on top of it.

Thanks.

-- 
tejun
