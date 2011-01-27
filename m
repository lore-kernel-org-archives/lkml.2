Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1A0Fzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:55:46 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54274 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750835Ab1A0Fzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:55:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=coly.li;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=schnXI0hrbkbgCNKu9GVOIFO/Y10we8LSsGQdjnoqXPd4woqUKBxrAY0XKZjD679n1RNMB4a/ipP/F2Ol4TbW0bhQAkHH1jylQx9beYjXYBci5h7STV81xkZZerpSqhf;
Message-ID: <4D410EF8.3070508@coly.li>
Date: Thu, 27 Jan 2011 14:21:44 +0800
From: Coly Li <i@coly.li>
Reply-To: i@coly.li
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/6] use BUG_ON correctly
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com> <AANLkTikq2YttapeLKkSeM-MrPoBdvPR32-oL6BdBOKdf@mail.gmail.com>
In-Reply-To: <AANLkTikq2YttapeLKkSeM-MrPoBdvPR32-oL6BdBOKdf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Identified-User: {1390:box585.bluehost.com:colyli:coly.li} {sentby:smtp auth 114.251.86.0 authed with i@coly.li}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年01月27日 10:02, Yong Zhang Wrote:
> On Thu, Jan 27, 2011 at 2:39 AM, Coly Li<bosong.ly@taobao.com>  wrote:
>> BUG_ON() already uses unlikely() inside its definition if possible,
>
> It's true for asm-generic/bug.h.
>
> But for archs which has defined HAVE_ARCH_BUG,
> unlikely() is not always included in it.
>

IMHO, if this condition happens, it should be a bug of the arch implementation, unless unlikely() is not really supported.

Coly

-- 
Coly Li
