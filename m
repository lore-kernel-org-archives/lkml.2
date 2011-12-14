Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab1LNT2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:28:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50419 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1LNT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:28:02 -0500
Message-ID: <4EE8F8B2.3020203@landley.net>
Date: Wed, 14 Dec 2011 13:27:46 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: slyich@gmail.com, aboriginal@lists.landley.net,
        linux-kernel@vger.kernel.org, tytso@mit.edu,
        sparclinux@vger.kernel.org, jakub@redhat.com
Subject: Re: Sparc-32 doesn't work in 3.1.
References: <20111214.125443.973289484729064945.davem@davemloft.net>	<20111214.131810.916491563666428853.davem@davemloft.net>	<20111214215516.26ffe884@sf.home> <20111214.141316.931101347023790867.davem@davemloft.net>
In-Reply-To: <20111214.141316.931101347023790867.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 01:13 PM, David Miller wrote:
> From: Sergei Trofimovich <slyich@gmail.com>
> Date: Wed, 14 Dec 2011 21:55:16 +0300
> 
>>> sparc32: Be less strict in matching %lo part of relocation.
>>>
>>> The "(insn & 0x01800000) != 0x01800000" test matches 'restore'
>>> but that is a legitimate place to see the %lo() part of a 32-bit
>>> symbol relocation, particularly in tail calls.
>>>
>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
>>
>> Was about to send exactly the same. Thanks!
> 
> Thanks for testing Sergei.
> 

Is that the line we're using now?  I'm out of touch...

Tested-by: Rob Landley <rob@landley.net>

Rob
