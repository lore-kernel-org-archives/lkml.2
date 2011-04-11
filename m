Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab1DKWmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:42:43 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:57109
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910Ab1DKWmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:42:42 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h637h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DA383D3.100@freescale.com>
Date: Mon, 11 Apr 2011 17:42:27 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.17) Gecko/20110307 Fedora/2.0.12-1.fc13 SeaMonkey/2.0.12
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
References: <20110411220345.9B95067C@kernel>	 <20110411220346.2FED5787@kernel>	 <20110411152223.3fb91a62.akpm@linux-foundation.org> <1302561360.7286.16848.camel@nimitz>
In-Reply-To: <1302561360.7286.16848.camel@nimitz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
>> > Hand-optimised.  Old school.  Doesn't trust the compiler :)

> Hey, ask the dude who put free_pages_exact() in there! :)

Ugh, I don't remember at all why I wrote it the way I did.  I'm pretty sure I
copied the style from somewhere else, since these functions are not really my
area of expertise.

When you guys finally agree on the order of the parameters :) I'll test out the
functions on my board.

-- 
Timur Tabi
Linux kernel developer at Freescale

