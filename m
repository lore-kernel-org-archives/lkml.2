Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1EMDTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:19:15 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51781 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab1EMDTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:19:14 -0400
Message-ID: <4DCCA317.2030302@metafoo.de>
Date: Thu, 12 May 2011 20:18:47 -0700
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "'Grant Likely'" <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: Question: GPIO driver how to get irq_base
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com> <4DB2A6A2.90803@metafoo.de> <614E530848124206BD1A074548078FA8@hacdom.okisemi.com> <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com> <4DCAE163.2050602@metafoo.de> <CCD653B68482426EA47A12055C9E19E5@hacdom.okisemi.com> <4DCC384B.1020202@metafoo.de> <CA2B589B92704A439D8DF3E2EAD9750D@hacdom.okisemi.com>
In-Reply-To: <CA2B589B92704A439D8DF3E2EAD9750D@hacdom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 07:40 PM, Tomoya MORINAGA wrote:
> Hi  Lars,
> 
> On Friday, May 13, 2011 4:43 AM, Lars-Peter Clausen wrote:
>> Is it already used at the time when you call irq_alloc_descs?
> 
> Since gpio driver with interrupt function must be integrated as built-in,
> I don't know whether "18" is already used or NOT at that time.
> If you have any information, let me know.
> 

Well, you should be able to figure that out with some debug printks, shouldn't you?

- Lars
