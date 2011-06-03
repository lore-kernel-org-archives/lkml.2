Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1FCSXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:23:17 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:5011 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751794Ab1FCSXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:23:16 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE92675.6080908@freescale.com>
Date: Fri, 3 Jun 2011 13:22:45 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
References: <1307119552-15573-1-git-send-email-timur@freescale.com> <BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
In-Reply-To: <BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> NAK
> It accesses userspace data twice.

What's wrong with that?  How else is it supposed to know how much to allocate
without using strlen first?

Besides, it was Alan's idea to make this a common function.  I can easily put it
back in my driver.

-- 
Timur Tabi
Linux kernel developer at Freescale

