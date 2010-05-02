Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0EBIfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 04:35:51 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:41995 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab0EBIfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 04:35:50 -0400
X-SENDER-IP: [83.226.250.226]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvdEANfV3EtT4vriPGdsb2JhbACBN4YylU0BAQEBNbhuhRIE
X-IronPort-AV: E=Sophos;i="4.52,311,1270418400"; 
   d="scan'208";a="69666351"
Message-ID: <4BDD395F.3040105@coyote.org>
Date: Sun, 02 May 2010 10:35:43 +0200
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100428 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, penberg@cs.helsinki.fi, pavel@ucw.cz, diegoliz@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds.c: converted long if-else to switch
References: <1268779048-21397-1-git-send-email-lindley@coyote.org> <20100428225129.GD24604@kroah.com>
In-Reply-To: <20100428225129.GD24604@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-04-29 00:51, Greg KH wrote:
> On Tue, Mar 16, 2010 at 11:37:28PM +0100, Lars Lindley wrote:
>> I converted the long if-else in function Mds_HeaderCopy() to a switch
>> instead. It compiles fine but i don't have the hardware to test.
>> Please check that I didn't do anything bad to it..
>> The patch applies on top of this patch:
>> Message-Id: <1268670973-6223-1-git-send-email-lindley@coyote.org>
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
> 
> This doesn't apply on top of linux-next, care to respin it?
> 
> thanks,
> 
> greg k-h
> 
Not sure what you want me to do.. :)

Regards, Lars
