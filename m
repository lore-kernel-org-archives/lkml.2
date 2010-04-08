Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab0DHSPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:15:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60500
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758895Ab0DHSPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:15:40 -0400
Date: Thu, 08 Apr 2010 11:15:42 -0700 (PDT)
Message-Id: <20100408.111542.185885813.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] IDE
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1004080800360.3586@i5.linux-foundation.org>
References: <20100408.013628.171442882.davem@davemloft.net>
	<alpine.LFD.2.00.1004080800360.3586@i5.linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Apr 2010 08:02:45 -0700 (PDT)

> 
> 
> On Thu, 8 Apr 2010, David Miller wrote:
>> 
>> 2) taskfile ops with CFQ scheduler bomb because the taskfile
>>    code allocates a request then changes it's direction (e.g.
>>    READ vs. WRITE) and this makes CFQ explode.  Fix by allocating
>>    the correct request type from the beginning.  From Mikulas Patocka.
> 
> Hmm. Isn't this -stable material too? At least ide-taskfile.c hasn't 
> changed since 2.6.33?

Absolutely and it's in my queue of things to send to Greg KH and
co. once you suck this in.
