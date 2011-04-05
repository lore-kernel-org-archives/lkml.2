Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1DEPKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:10:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:45448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1DEPKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:10:12 -0400
Message-ID: <4D9B30D1.2090406@suse.cz>
Date: Tue, 05 Apr 2011 17:10:09 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: dedekind1@gmail.com
Cc: linux-kbuild@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: Re: [PATCH 16/34] nand/denali: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>	 <1302015561-21047-17-git-send-email-mmarek@suse.cz> <1302015767.2760.145.camel@localhost>
In-Reply-To: <1302015767.2760.145.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.4.2011 17:02, Artem Bityutskiy wrote:
> On Tue, 2011-04-05 at 16:59 +0200, Michal Marek wrote:
>> The kernel already prints its build timestamp during boot, no need to
>> repeat it in random drivers and produce different object files each
>> time.
>>
>> Cc: Chuanxiao Dong <chuanxiao.dong@intel.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: linux-mtd@lists.infradead.org
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> Do you want this to got via the MTD tree or you'd rather merge it with
> the rest of the patches via some other tree? In any case,

The patches do not depend on each other, so they should go via the usual
trees.


> Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Thanks.
Michal
