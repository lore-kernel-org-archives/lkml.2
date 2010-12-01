Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0LASpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:45:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50387
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab0LASpT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:45:19 -0500
Date: Wed, 01 Dec 2010 10:45:46 -0800 (PST)
Message-Id: <20101201.104546.39187178.davem@davemloft.net>
To: dpstrand@gmail.com
Cc: fubar@us.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: check for assigned mac before adopting the
 slaves mac address
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=+jMkrgNjVQvOOn_zURiJ4rXu5LL9eA4o0T9db@mail.gmail.com>
References: <AANLkTi=-DzUmopboX13V_cd=mZnmD=mBNNCuhQYF0PQQ@mail.gmail.com>
	<8879.1290741991@death>
	<AANLkTi=+jMkrgNjVQvOOn_zURiJ4rXu5LL9eA4o0T9db@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Strand <dpstrand@gmail.com>
Date: Wed, 1 Dec 2010 10:25:19 -0800

> On Thu, Nov 25, 2010 at 7:26 PM, Jay Vosburgh <fubar@us.ibm.com> wrote:
>>
>>        Ok, fair enough.  If we want to get back to the original
>> behavior, however, your patch should only test for zero MAC address
>> instead of testing for zero MAC address in addition to first slave.
>>
>>        -J
>>
>> ---
>>        -Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
>>
> 
> Understood, that makes sense. The updated patch is below.

You need to provide a fresh posting of your patch, with a full
commit messag and proper Subject: line, as well as a proper
"Signed-off-by: " tag.

See Documentation/SubmittingPatches
