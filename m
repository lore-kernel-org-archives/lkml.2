Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab2IKR4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:56:21 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38038 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab2IKR4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:56:19 -0400
Message-ID: <504F7B4D.3030602@metafoo.de>
Date: Tue, 11 Sep 2012 19:56:29 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH v2 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
References: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de> <504E0542.8020309@metafoo.de> <20120910173056.GA31611@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120910173056.GA31611@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 07:30 PM, Thierry Reding wrote:
> On Mon, Sep 10, 2012 at 05:20:34PM +0200, Lars-Peter Clausen wrote:
>> On 09/10/2012 02:05 PM, Thierry Reding wrote:
>>> Hi,
>>>
>>
>> [...]
> 
>> Patch 1 should go through the MIPS tree, but I still can't see why the issue
>> should occur nor does it happen for anybody else except for you. Instead of
>> moving the content over to the public irq.h I'd rather like to see the
>> private irq.h being renamed.
> 
> If we can solve this some other way I'm all for it. Maybe you can share
> the defconfig or .config that you use so I can test under the same
> conditions.
> 
> Thierry

This is the config I'm using:
http://projects.qi-hardware.com/index.php/p/qi-kernel/source/tree/jz-3.4/arch/mips/configs/qi_lb60_defconfig

- Lars

