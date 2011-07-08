Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab1GHR7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:59:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1GHR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:59:50 -0400
Message-ID: <4E174593.20107@gmail.com>
Date: Fri, 08 Jul 2011 12:59:47 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux@arm.linux.org.uk
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Barry Song <21cnbao@gmail.com>,
        workgroup.linux@csr.com, Olof Johansson <olof@lixom.net>,
        tglx@linutronix.de, weizeng.he@csr.com
Subject: Re: [PATCH v4 2/2] ARM: l2x0: Add OF based initialization
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com> <1309984979-8847-2-git-send-email-robherring2@gmail.com> <20110706210237.GB5371@ponder.secretlab.ca> <201107062326.53737.arnd@arndb.de>
In-Reply-To: <201107062326.53737.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On 07/06/2011 04:26 PM, Arnd Bergmann wrote:
> On Wednesday 06 July 2011 23:02:37 Grant Likely wrote:
>>
>> On Wed, Jul 06, 2011 at 03:42:59PM -0500, Rob Herring wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> This adds probing for ARM L2x0 cache controllers via device tree. Support
>>> includes the L210, L220, and PL310 controllers. The binding allows setting
>>> up cache RAM latencies and filter addresses (PL310 only).
>>>
>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> By rights, this should go via the arm tree, but it depends on patches
>> that are already in devicetree/next.  Arnd, how do you want to handle
>> this?  I want to avoid rebasing devicetree/next.
> 
> It's outside of the scope of the arm-soc tree really, the l2x0 code
> is clearly core arm stuff, so it belongs into Russell's tree.
> 
> I think it's best if Russell can provide an Ack for this and you
> put it in the tree that already has the dependencies.
> 

Any comments?

Rob
