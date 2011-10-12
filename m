Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1JLF3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 01:29:23 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19352 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab1JLF3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 01:29:22 -0400
Message-ID: <4E9525AC.9080909@dsn.lapis-semi.com>
Date: Wed, 12 Oct 2011 14:29:16 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: linux-next: build failure after merge of the gpio tree
References: <20111006144826.a69a5ea59d4ca94f8f7414cf@canb.auug.org.au>	<20111011173714.d54bbcee6c0676ddcc37a1f3@canb.auug.org.au>	<4E93EA10.4030405@dsn.lapis-semi.com> <20111012152451.66ce5ddffb4c5b3a4f6a31cf@canb.auug.org.au>
In-Reply-To: <20111012152451.66ce5ddffb4c5b3a4f6a31cf@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen

(2011/10/12 13:24), Stephen Rothwell wrote:
> 
> Just try building gpio-pch and gpio-ml-ioh as modules ...
> irq_setup_generic_chip() does not have an EXPORT_SYMBOL (and didn't in
> v3.0 either).
> 

Your report looks like the same as ours.
In our develop environment,
build becomes success only gpio-pch/gpio-ml-ioh is integrated as built-in.
In case of integrated as modules, build becomes failure.

I understood this behavior is specification/limitation of GPIO interrupt
function.
Is it true ?

-- 
tomoya
ROHM Co., Ltd.
