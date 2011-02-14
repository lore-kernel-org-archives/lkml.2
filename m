Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1BNTa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:30:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1BNTaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mpl+lTivHPAAsOY1jfbQhWeDOm88BwPLeRKQYi46NVJxFVWXPBi9cUIGZq2EdY5zHe
         EH34TqBwYkjkcVI1CUMCC0qA+SGHR5tFtLkpa6LR9QVdAxCsFld6pFp3THPMSRRa/v3y
         GxaE2JLSGS1grGaZsdN6QFJZFBBfOM7rip9ho=
Date: Mon, 14 Feb 2011 20:30:50 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110214193050.GC18742@htj.dyndns.org>
References: <1297530663-26234-16-git-send-email-tj@kernel.org>
 <4D5729A7.7070706@kernel.org>
 <20110214113221.GG18742@htj.dyndns.org>
 <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
 <20110214161249.GV18742@htj.dyndns.org>
 <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
 <20110214162247.GX18742@htj.dyndns.org>
 <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
 <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D597D56.5060408@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:07:02AM -0800, Yinghai Lu wrote:
> Never mind. will send out patch after your patches get merged into tip.

Alright, fair enough.

> BTW, you may need to rebase your on top of tip/master.

Yeah, I saw a new patch going into the numa branch, but shouldn't this
and the next series based on x86/numa?  That was how it was done with
the previous series.

Thanks.

-- 
tejun
