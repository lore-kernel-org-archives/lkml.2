Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0C0Xbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:31:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42942
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118Ab0C0Xbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:31:35 -0400
Date: Sat, 27 Mar 2010 16:31:59 -0700 (PDT)
Message-Id: <20100327.163159.102547305.davem@davemloft.net>
To: rob@landley.net
Cc: blauwirbel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201003270244.17865.rob@landley.net>
References: <201003262235.48736.rob@landley.net>
	<20100326.203745.04177541.davem@davemloft.net>
	<201003270244.17865.rob@landley.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>
Date: Sat, 27 Mar 2010 02:44:16 -0500

> On Friday 26 March 2010 22:37:45 David Miller wrote:
>> From: Rob Landley <rob@landley.net>
>> Date: Fri, 26 Mar 2010 22:35:47 -0500
>>
>> > What exactly was the problem with just saying "unsigned short" when you
>> > mean an unsigned short?  The way x86 does, and arm?  (If these ever
>> > change, it breaks binary compatability.  Not sure what these changes were
>> > trying to accomplish...)
>>
>> I was trying to use well defined types that described the
>> usage and the origin of the definition.
>>
>> I'm happy to use "unsigned short" or whatever works better.
>> Please send a patch.
> 
> Sure thing:

Thanks a lot Rob, applied.

Please supply a complete commit log message and place your signoff
right before (instead of after) the patch next time, thanks!
