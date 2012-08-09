Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab2HIPWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:22:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44169 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430Ab2HIPWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:22:40 -0400
Message-ID: <1344525758.3165.8.camel@joe2Laptop>
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Ren, Cloud" <cjren@qca.qualcomm.com>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "hao-ran.liu@canonical.com" <hao-ran.liu@canonical.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Date: Thu, 09 Aug 2012 08:22:38 -0700
In-Reply-To: <20120809145454.GA21195@home.goodmis.org>
References: <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
	 <1344485382.2024.9.camel@joe2Laptop>
	 <6349D7A510622448B1BA0967850A843801369364@NASANEXD02D.na.qualcomm.com>
	 <20120808.231804.12694947300243733.davem@davemloft.net>
	 <6349D7A510622448B1BA0967850A8438013693DD@NASANEXD02D.na.qualcomm.com>
	 <20120809145454.GA21195@home.goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 10:54 -0400, Steven Rostedt wrote:
> On Thu, Aug 09, 2012 at 06:49:25AM +0000, Ren, Cloud wrote:
> > Luis has ever asked joe for adding as a Signed-off-by.
[]
> I'm curious, did Luis ask on list or off?

Off vger lists with some qca list or exploder added.

> The Signed-off tag has some legal bindings (all other tags are for
> credit/info only). It is that person saying that the changes they made
> to a patch are theirs and are giving the right to distribute it.

I believe I posted all patches I signed-off to vger lists.

>   The sign-off is a simple line at the end of the explanation for the
>   patch, which certifies that you wrote it or otherwise have the right to
>   pass it on as an open-source patch.
> 
> Joe, If you actually modified part of the code in the patch, you do have
> the right to add a signed-off-by tag. If you just made suggestions or
> reviewed, then a 'Suggested-by' or 'Reviewed-by' tag would be more
> appropriate.

Yes, I sent signed-off patches to their original RFC submission
(back last year?).  To me, this single large patch is like a
snapshot of a git tree and not all contributors to that git
tree should be noted as signers of the entire thing.


