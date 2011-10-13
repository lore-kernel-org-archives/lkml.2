Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1JMIWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:22:13 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26022 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab1JMIWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:22:11 -0400
Message-ID: <4E969FAE.5000909@dsn.lapis-semi.com>
Date: Thu, 13 Oct 2011 17:22:06 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the gpio tree
References: <20111006144826.a69a5ea59d4ca94f8f7414cf@canb.auug.org.au> <20111011173714.d54bbcee6c0676ddcc37a1f3@canb.auug.org.au> <4E93EA10.4030405@dsn.lapis-semi.com> <20111012152451.66ce5ddffb4c5b3a4f6a31cf@canb.auug.org.au> <4E9525AC.9080909@dsn.lapis-semi.com> <CABMQnV+S2WbW0YZBiMXfs81b2dyLzj9wBxPmNuFrYErKfXsWtg@mail.gmail.com> <4E9551B8.4060601@dsn.lapis-semi.com> <20111013035714.GD15829@ponder.secretlab.ca>
In-Reply-To: <20111013035714.GD15829@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/13 12:57), Grant Likely wrote:
> I've temporarily pushed out a commit that makes the pch and ml_ioh
> bool instead of tristate.  If that other patch gets acked by Thomas,
> then I should probably take it through the gpio tree.
Let me clarify your intention.
Does previous patch for generic-chip posted by Nobuhiro enable 
pch/ml_ioh gpio driver works on both module and built-in ?
If yes, why do you need to change tristate to bool ?

-- 
tomoya
ROHM Co., Ltd.
