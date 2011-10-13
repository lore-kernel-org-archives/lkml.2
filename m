Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1JMPuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:50:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:34633 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1JMPun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:50:43 -0400
Subject: Re: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit systems
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AE7E@saturn3.aculab.com>
Date: Thu, 13 Oct 2011 10:50:17 -0500
Cc: "Timur Tabi" <timur@freescale.com>, <linuxppc-dev@ozlabs.org>,
        <hjk@hansjkoch.de>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        "Jiang Kai-B18973" <B18973@freescale.com>
Content-Transfer-Encoding: 7bit
Message-Id: <9FAA2091-2FED-4B44-9224-6C735CF51D2C@kernel.crashing.org>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AE7E@saturn3.aculab.com>
To: David Laight <David.Laight@ACULAB.COM>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13, 2011, at 10:37 AM, David Laight wrote:

> 
>> Kumar Gala wrote:
>>>>>>> +       phys_addr_t             addr;
>>>>> 
>>>>> Please add a comment here saying:
>>>>> 
>>>>> 1) That 'addr' can be a virtual or physical address
>>> The code and everything else makes that clear
>> 
>> I'm sorry, but I have to strongly disagree here.  It is *NOT* 
>> clear that a variable of type 'phys_addr_t' can hold something
>> that is not a physical address.
> 
> Since there is a discriminating field, could a union be used?
> At a guess the type of the address is constrained between
> produces and consumer??

Uugh.

I'll add a comment to uio_mem.

- k
