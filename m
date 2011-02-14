Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1BNQIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:08:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42090 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab1BNQIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CQXubvX6a7rWRuaPr83JgujqzKkFN6ZSdY5Iqto0ZFjnn/Q3EWCwx094k49FC1My5V
         A8fAY8lOLF0O/EZqM7qrdExrXEhFjH3s8nBPq4gn/KJXlaqAPCA3+B+utVyjas4d5y5n
         su+smZCZvGpAezvYxGOEqGI/1km1CgZEmjbx4=
MIME-Version: 1.0
In-Reply-To: <20110214113221.GG18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-16-git-send-email-tj@kernel.org>
	<4D5729A7.7070706@kernel.org>
	<20110214113221.GG18742@htj.dyndns.org>
Date: Mon, 14 Feb 2011 08:08:08 -0800
X-Google-Sender-Auth: Jkb8sEdJ67KNqHqgByF2D1x9m7Q
Message-ID: <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 3:32 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sat, Feb 12, 2011 at 04:45:27PM -0800, Yinghai Lu wrote:
>> please don't put setup_node_bootmem calling into numa_register_memblks()
>> that is not related.
>>
>> put the calling in initmem_init() directly is more reasonable.
>
> No, I don't think so.  If you don't like the function name, let's
> change the name.  I think it's better to put all registrations there.
> Later in the series but function is changed to deal with struct
> numa_meminfo anyway so maybe it's better to rename it to
> numa_register_meminfo().

No, I don't like ***_register_*** take care of calling setup_bootmem.

Yinghai
