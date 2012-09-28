Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2I1MGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:06:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44777 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2I1MGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:06:42 -0400
Date: Fri, 28 Sep 2012 08:06:07 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-karma-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omfs: convert to use beXX_add_cpu()
Message-ID: <20120928120607.GA18992@localhost>
References: <CAPgLHd-cc+_6316S9NxBFXHLdjM0trf1QvPt3aXhAE9on9u9WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-cc+_6316S9NxBFXHLdjM0trf1QvPt3aXhAE9on9u9WA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:51:01PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Convert cpu_to_beXX(beXX_to_cpu(E1) + E2) to use beXX_add_cpu().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks,

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
