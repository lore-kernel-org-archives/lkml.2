Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0ESQsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:48:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:50747 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab0ESQsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:48:05 -0400
Message-ID: <4BF4163A.503@kernel.org>
Date: Wed, 19 May 2010 18:47:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/17] wireless: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>	<1269885165-18617-11-git-send-email-tj@kernel.org>	<20100519190230.52385a65.sfr@canb.auug.org.au>	<20100519144505.GD2412@tuxdriver.com>	<20100520012829.709931dc.sfr@canb.auug.org.au>	<4BF407C9.2020202@kernel.org> <20100520023111.1755c938.sfr@canb.auug.org.au>
In-Reply-To: <20100520023111.1755c938.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 16:47:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 06:31 PM, Stephen Rothwell wrote:
> Hi Tejun,
> 
> On Wed, 19 May 2010 17:46:17 +0200 Tejun Heo <tj@kernel.org> wrote:
>>
>> Yeap, I hoped that more of them would sort themselves out during devel
>> cycle, but I guess rc1 window isn't too bad.
> 
> I have now reposted all the outstanding ones.

Thanks for taking care of them.  :-)

-- 
tejun
