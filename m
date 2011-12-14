Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1LNTNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:13:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60568 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1LNTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:13:32 -0500
Date: Wed, 14 Dec 2011 14:13:16 -0500 (EST)
Message-Id: <20111214.141316.931101347023790867.davem@davemloft.net>
To: slyich@gmail.com
Cc: rob@landley.net, aboriginal@lists.landley.net,
        linux-kernel@vger.kernel.org, tytso@mit.edu,
        sparclinux@vger.kernel.org, jakub@redhat.com
Subject: Re: Sparc-32 doesn't work in 3.1.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111214215516.26ffe884@sf.home>
References: <20111214.125443.973289484729064945.davem@davemloft.net>
	<20111214.131810.916491563666428853.davem@davemloft.net>
	<20111214215516.26ffe884@sf.home>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 14 Dec 2011 11:13:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyich@gmail.com>
Date: Wed, 14 Dec 2011 21:55:16 +0300

>> sparc32: Be less strict in matching %lo part of relocation.
>> 
>> The "(insn & 0x01800000) != 0x01800000" test matches 'restore'
>> but that is a legitimate place to see the %lo() part of a 32-bit
>> symbol relocation, particularly in tail calls.
>> 
>> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Was about to send exactly the same. Thanks!

Thanks for testing Sergei.
