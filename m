Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1BOJ2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:28:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34548 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1BOJ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:28:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IEngQkW2/4VjqYlFy9bmqdDkl4bduerQS91jnjo0AY8gNMtmtpcNBisYJKIvM5BIAh
         9h1DjsJL38iLATbqkcm7T7z8bx55GGkG2ekNT26JRTST9Oee9I+3OqduCLifHExy0j+8
         F35wv3nyWhOe2nTUbtQx/q/U8oDhZcBwJ4UFo=
Date: Tue, 15 Feb 2011 10:26:33 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA
 emulation
Message-ID: <20110215092633.GF3160@htj.dyndns.org>
References: <1297711715-3086-1-git-send-email-tj@kernel.org>
 <AANLkTikNy-vQ2V95dhyQ8k1jkQCiUOukY8ShP_GWM1w6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikNy-vQ2V95dhyQ8k1jkQCiUOukY8ShP_GWM1w6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 12:00:43PM -0800, Yinghai Lu wrote:
> wonder if numa_emu code could be put into one single file like
> numa_emu.c

Yeah, it isn't difficult at all.  After the series, emulation code is
isolated into <400 lines of code and the states it modifies is
immediately apparent.  We can just move all the functions inside
CONFIG_NUMA_EMU and let initmem_init() pass all the states which are
necessary for emulation to numa_emulation().  If that's desirable,
I'll send a patch to do that on top once the whole thing settles a
bit.

Thanks.

-- 
tejun
