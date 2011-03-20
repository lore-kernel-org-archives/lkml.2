Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab1CTOnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 10:43:46 -0400
Received: from stinky.trash.net ([213.144.137.162]:44694 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1CTOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 10:43:42 -0400
Message-ID: <4D861298.1040700@trash.net>
Date: Sun, 20 Mar 2011 15:43:36 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] ipv4: netfilter: ipt_CLUSTERIP: fix buffer overflow
References: <1299780740-32652-1-git-send-email-segoon@openwall.com> <AANLkTimPZJoCzz386e-4m0Y4khWGZirZguGFmuFYCrry@mail.gmail.com> <4D7F5CAC.6070006@trash.net> <20110317113229.GA7710@albatros> <AANLkTimtsB0B98E2xcoJgRsPwSpwuG+ahT+LX0s1YwpX@mail.gmail.com>
In-Reply-To: <AANLkTimtsB0B98E2xcoJgRsPwSpwuG+ahT+LX0s1YwpX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.03.2011 13:15, schrieb Changli Gao:
> On Thu, Mar 17, 2011 at 7:32 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> 'buffer' string is copied from userspace.  It is not checked whether it is
>> zero terminated.  This may lead to overflow inside of simple_strtoul().
>> Changli Gao suggested to copy not more than user supplied 'size' bytes.
>>
>> It was introduced before the git epoch.  Files "ipt_CLUSTERIP/*" are
>> root writable only by default, however, on some setups permissions might be
>> relaxed to e.g. network admin user.
>>
>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> Acked-by: Changli Gao <xiaosuo@gmail.com>
> 
> 

Applied, thanks everyone.
