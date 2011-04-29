Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1D2BAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 21:00:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1D2BAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 21:00:46 -0400
Message-ID: <4DBA0E5A.2090905@cn.fujitsu.com>
Date: Fri, 29 Apr 2011 09:03:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patchwork [-rcu,1/1] rcu: fix rcu CONFIG logic
References: <BANLkTikoT4vHDjeNpoVWzefqMRBFAC0unA@mail.gmail.com>
In-Reply-To: <BANLkTikoT4vHDjeNpoVWzefqMRBFAC0unA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-29 09:01:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-29 09:01:03,
	Serialize complete at 2011-04-29 09:01:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 07:17 PM, Sedat Dilek wrote:
> Hi Lai Jiangshan,
> 
> I like this patch (with explanations) and would test it, against which
> (GIT) tree is this for?
> 

https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/kfree_rcu


> 
> 
> [1] https://patchwork.kernel.org/patch/735291/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

