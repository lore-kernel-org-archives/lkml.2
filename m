Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1BNQN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:13:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1BNQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Fb5nQ+eNkdjSqtQIdOZjSZhuCEIC7nTRTQimsmsdu85QH7SuyQa2fy26m36L/27jJk
         leoqXAq6U5qX9wKymWwiDgj08sVadE3QVKUI+gNsqzDTO7n69mQj1F3gay7Cg4kt+yXR
         CJ6g7lXOjopUOGwXAtFTQqwebeaxDW2KUod68=
Date: Mon, 14 Feb 2011 17:12:49 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110214161249.GV18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-16-git-send-email-tj@kernel.org>
 <4D5729A7.7070706@kernel.org>
 <20110214113221.GG18742@htj.dyndns.org>
 <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 08:08:08AM -0800, Yinghai Lu wrote:
> > No, I don't think so.  If you don't like the function name, let's
> > change the name.  I think it's better to put all registrations there.
> > Later in the series but function is changed to deal with struct
> > numa_meminfo anyway so maybe it's better to rename it to
> > numa_register_meminfo().
> 
> No, I don't like ***_register_*** take care of calling setup_bootmem.

Yeah, then, please go ahead and suggest the name you want.  I don't
really care about the name itself, but I don't want to put it directly
in initmem_init() because with double calling and extra loop added
later it gets nested too deep.  For now, let's move on, okay?  We can
argue about this for days but there's no clear technical
[dis]advantage one way or the other and falls squarely in the scope of
bikeshedding.

Thanks.

-- 
tejun
