Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0DQPGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 11:06:21 -0400
Received: from web111920.mail.gq1.yahoo.com ([67.195.22.76]:26769 "HELO
	web111920.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752524Ab0DQPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 11:06:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=2X5dFRrfErbMBJ2lv1uuIwV2+VzO/IhWPvrp0Z1YqsyP01ART4E/LtJE4Y1Du/DoIMMFKzMfr3HpHJXoX0u/DjkV0GHcnGEKLQ0eOb/1KemiG/mwyPbCgujDKZ0+HQPnDjVvc/bkt7Bi71xeAYe+iY98gE3l6Q8Kk9Mz51obCyY=;
Message-ID: <398794.47398.qm@web111920.mail.gq1.yahoo.com>
X-YMail-OSG: UDqv1CcVM1kzGISI32XbI7eMtZEKBjpsQF4yFLcYcmuFj4d
 wniDp3h_37esTEe1r8dGmUQ6KvjbIo4gFEbbOYGqvnXqYQdUUmSfpkPFUKcp
 Lcci0qk4jS39wpriLpqlQRDW2Nrwvzv5yrt_ibVsndrw5yuJciBqcxgAWSpn
 mmiTFtIO7XOV8NQXy814gBDYHXasq22HTwL.4yjzGPyH7SIevDuSq9mZGlrM
 YlbTHjcsYDkMwJurZzpI0tS3.lZxmoV4YevG.qg3BPchruybs6HG59zdpkjJ
 Z4UxTn0X9XQfB
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.100.260964
Date: Sat, 17 Apr 2010 07:59:36 -0700 (PDT)
From: Chetan Loke <generationgnu@yahoo.com>
Subject: Re: Memory policy question for NUMA arch....
To: Andi Kleen <andi@firstfloor.org>
Cc: rick.sherm@yahoo.com, andi@firstfloor.org, linux-numa@vger.kernel.org,
       linux-kernel@vger.kernel.org, generationugnu@yahoo.com
In-Reply-To: <20100417063523.GC18855@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

--- On Sat, 4/17/10, Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> Subject: Re: Memory policy question for NUMA arch....
> To: "Chetan Loke" <generationgnu@yahoo.com>
> Cc: rick.sherm@yahoo.com, andi@firstfloor.org, linux-numa@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Saturday, April 17, 2010, 6:35 AM
> > I may be wrong but I think
> there's a difference. system-wide run-time default policy is
> M_PREFERRED | M_LOCAL and not Interleaving.
> 
> The policy at early kernel boot time (before mounting root)
> is interleaving.
> 
Yup. 

PS - What do you think about __get_free_policy_pages(..)? Good/bad idea?

> -Andi
> 

thanks
Chetan Loke


      
