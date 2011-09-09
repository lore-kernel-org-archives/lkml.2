Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab1IIJyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:54:25 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:12899 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab1IIJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:54:24 -0400
Message-ID: <4E69E21F.5070701@atmel.com>
Date: Fri, 09 Sep 2011 11:53:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: dedekind1@gmail.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nico Erfurth <ne@erfurth.eu>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the at91 tree
References: <20110909132920.3696fbb6c1b90cded9727d30@canb.auug.org.au> <1315550734.7905.14.camel@sauron> <20110909164539.bae897109d3de0e67f0db69a@canb.auug.org.au>
In-Reply-To: <20110909164539.bae897109d3de0e67f0db69a@canb.auug.org.au>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/09/2011 08:45, Stephen Rothwell :
> Hi Artem,
> 
> On Fri, 09 Sep 2011 09:45:28 +0300 Artem Bityutskiy
> <dedekind1@gmail.com> wrote:
>> 
>> OK, thanks, I guess you'll carry this modification so far, we'll
>> need to take care of the conflict when merging.
> 
> Yep, no worries.

Stephen,

I have seen the two manual merges that you made concerning our
at91-next tree. This is when we realize how linux-next is a great tool ;-)

So, as I am not so used to this kind of situation, I wonder if I need
to included those two patches from Russell's and Artem's git trees in
our at91-next one or if I only carry on with current patch series
until Linus merges all this himself?

Best regards,
-- 
Nicolas Ferre

