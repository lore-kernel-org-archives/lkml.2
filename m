Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab2LIM7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 07:59:43 -0500
Received: from nm17.bullet.mail.bf1.yahoo.com ([98.139.212.176]:20336 "EHLO
	nm17.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934096Ab2LIM7m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 07:59:42 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 786737.92955.bm@omp1014.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5Xdup/vCBQ7cZtHMzw8Y/4CA/K6tOKQpiK30mloVqN+hJLxzhm26xZNMGs5+RN3O4gfpa41vNQeX8knTVZkwBdeF9mxKIH/YIoYlOyewKGnABN4u+eDITtF/kK9J1sI46YZEkWPB7vx+XYUAVcfJEDhYoOLWpf3I6dmsPNVKoeQ=;
X-YMail-OSG: hqoWlAoVM1l7F_mAiYHADBaOhXZkG72bCt6eIijYjNDRC3g
 RLzCJedLvkm84RZR5RLY8vbkZ.opNlp6x9ywy4OS0ZX4B_2y7ShuL.Vt36B5
 34jQsYv4GuXNOJp7xpFx7cfaouoweSHeUsVZ3qxwItiSf0pp_76IN9dGOL17
 gZp8jXc7vmAV3WM0G4u4VGEHhA60EI9B9giOXtDHpovy5jXAy6tdIP37WJ3b
 FNRNDsg2kKm.2fb2zn4T303qIpQw6vedqVla9F9GLGXhYWtMGjs0NOf.v7qC
 7qrzFvNrqv3bx_ba8iO07esto0q7tU8gYdr24ifTM5LkpLuAiH2_7Azr0wVs
 DN.Duf_I1S9igl2UpwAnPcod4r7.nvipSaOGByJsQgFcjjMroJspx4dyGuhB
 leD2NkuqaC1XWjou3atsygp5BO_6IJkGGkGLQVgafEFtKXVqW44iiJR_Fq8X
 syefkT1tuwzRtSuBMgNh208VEG_UEpIH0torXxo.ReoSecf2ewMACLHSCzce
 .K6RCTEkV9v8ypkk.A8.ErJc-
X-Rocket-MIMEInfo: 001.001,PiBPaCwgbWF5YmUgSSB3YXNuJ3QgY2xlYXIgLSBJIHdhc24ndCB0YWxraW5nIGFib3V0IHN0YXRpc3RpY2FsCgo.IHNpZ25pZmljYW5jZSBidXQgcmF0aGVyIGFib3V0IHByYWN0aWNhbCBzaWduaWZpY2FuY2UuCgpPSy4gwqBJIHdpbGwgbm90IGFyZ3VlIHdpdGggdGhhdCA6KQoKPiBBIG1pbnVzY3VsZSBzcGVlZHVwIChhIGxvdCBsZXNzIHRoYW4gMSUpIHNob3dpbmcgb25seSBpbiBhICpzaW5nbGUqCj4gd29ya2xvYWQgc28gZmFyIGFuZCByZWxldmFudCBvbmx5IGZvciBhICp2ZXJ5KiAqc21hbGwqIG51bWIBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.128.478
References: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com> <20121205222738.GB6239@liondog.tnic> <1354748412.17691.YahooMailNeo@web140005.mail.bf1.yahoo.com> <20121205230835.GF6222@liondog.tnic> <1354968839.35825.YahooMailNeo@web140006.mail.bf1.yahoo.com> <20121209111857.GC24106@liondog.tnic> <1355054935.13447.YahooMailNeo@web140004.mail.bf1.yahoo.com> <20121209122907.GD24106@liondog.tnic>
Message-ID: <1355057981.88866.YahooMailNeo@web140001.mail.bf1.yahoo.com>
Date: Sun, 9 Dec 2012 04:59:41 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [PATCH] Expand CPU compiler options
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20121209122907.GD24106@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, maybe I wasn't clear - I wasn't talking about statistical

> significance but rather about practical significance.

OK.  I will not argue with that :)

> A minuscule speedup (a lot less than 1%) showing only in a *single*
> workload so far and relevant only for a *very* *small* number of linux
> users - only those who build their own kernels - is simply not worth
> including in the kernel.


My only confusion is why some of these are already included in the linux kernel source today, for example CORE2.  As I stated in my previous email, the two 'new' ones I tested preform as-good-as or better-than the CORE2 which is already included.  Does my confusion make sense?

Thanks again for the consideration!
