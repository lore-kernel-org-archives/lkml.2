Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1BNQYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:24:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49308 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1BNQYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:24:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ar0omz1kpwYqpzUAqqWQivdR803gh9Ep6haxC/nyMLoL0YcXZ/gMIQOdF3aYIxfiWY
         HRr+HEa4q8O9W4hGJDjDA49ry58Mf8BiM5n4vgyX6kYYxPdlFc4Bw72n9f54MhZ2OIOo
         eltsT9L0/b5Syv/FIzNYXg3cLFCQS7K5Ge3E4=
Date: Mon, 14 Feb 2011 17:22:47 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110214162247.GX18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-16-git-send-email-tj@kernel.org>
 <4D5729A7.7070706@kernel.org>
 <20110214113221.GG18742@htj.dyndns.org>
 <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
 <20110214161249.GV18742@htj.dyndns.org>
 <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 08:17:46AM -0800, Yinghai Lu wrote:
> why not do it at first point ?
> 
> numa_register_meminfo() should only take care of creating correctly
> struct numa_meminfo.

No, register meminfo doesn't create numa_meminfo.  It sets up system
states according to the configuration information in numa_meminfo, and
I really have no idea what you're arguing for or against.  What's your
point?

-- 
tejun
