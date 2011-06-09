Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1FITZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:25:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:34970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab1FITZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:25:23 -0400
Message-ID: <4DF11E15.5030907@infradead.org>
Date: Thu, 09 Jun 2011 16:25:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 8 (docbook/media)
References: <20110608161046.4ad95776.sfr@canb.auug.org.au> <20110608125243.e63a07fc.randy.dunlap@oracle.com>
In-Reply-To: <20110608125243.e63a07fc.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Em 08-06-2011 16:52, Randy Dunlap escreveu:
> On Wed, 8 Jun 2011 16:10:46 +1000 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 20110607:
> 
> 
> Hi Mauro,
> 
> The DocBook/media/Makefile seems to be causing too much noise:
> 
> ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.gif: No such file or directory
> ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.png: No such file or directory
>
> Maybe the cleanmediadocs target could be made silent?

I'll take a look on it. 

FYI, The next build will probably be noisier, as it is now pointing to some 
documentation gaps at the DVB API. Those gaps should take a longer time to fix, 
as we need to discuss upstream about what should be done with those API's,
that seems to be abandoned upstream (only one legacy DVB driver uses them).
However, I was told that some out-of-tree drivers and some drivers under development
are using them.

So, I intend to wait until the next merge window before either dropping those 
legacy API specs (or moving them to a deprecated section) or to merge those
out-of-tree drivers, with the proper documentation updates.

> also, where is the mediaindexdocs target defined?

Thanks for noticing it. We don't need this target anymore. I'll write a patch
removing it.

Cheers,
Mauro.
