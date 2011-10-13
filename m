Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1JMPlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:41:24 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28377 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1JMPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:41:23 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E970690.3080207@freescale.com>
Date: Thu, 13 Oct 2011 10:41:04 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Kumar Gala <galak@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
        <hjk@hansjkoch.de>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        Jiang Kai-B18973 <B18973@freescale.com>
Subject: Re: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit
 systems
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AE7E@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AE7E@saturn3.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Laight wrote:
> Since there is a discriminating field, could a union be used?
> At a guess the type of the address is constrained between
> produces and consumer??

I don't think we need to complicate the code by changing that variable into a
union.  I just a want a short comment added to the structure definition.  I
don't think that's asking a lot.

-- 
Timur Tabi
Linux kernel developer at Freescale

