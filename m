Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab2LIMOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 07:14:09 -0500
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:35066 "EHLO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755705Ab2LIMOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 07:14:07 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2012 07:14:07 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 290901.32009.bm@omp1068.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Rrra6Du4OjPLxLHAv5PNDKX4sa6cLiziyCvQ+FZdh0noauazpRQmq2UaciR0/hPrltq7iiIz/3YCg3K7rChmLATi9xEvvkt+bDkWR42Wtc46fYj6W4sD6d04aKQAi25yXoll9b/VmVAh4ozNB2h6LnYf2zD6qKpOFKLHVfSJSeo=;
X-YMail-OSG: s4MzVwgVM1nvR.QiqbYQMjjcsm5FDy7wb9Su9sCyPSFiwOZ
 64h7ob3a1MPBjs6G7VARXpMb.tbqRlYFr_pewVH7FQNIbPPFibgr2AbEg4dy
 9rfL1s.NSA90otAmNTgUWwI7rKcnuwPySwpdtrsFK_jE87hYsbHur82VZ0VZ
 rBkInTQPL8YQ_UHeu8EigxMo_Mt3zpT8voH7ZGPcbqTeRcmd6u6ctAx_w65I
 X4rV3JubxDbgmRaJArO7_J2Ypvd3pj0.2iPOpL5JGlbXzKBbOlp9A9l4wF4E
 3HRNyGXOcYrGuO1c2luyX5Q0L6zT5crWU1WjrNGF.RQW2coQHboqKLpeqRcm
 r7GpiIWEjWOTQTLM1.9_3eqjB1PmJYpGU9eXr0dRM5VHgHlFr7hzZ_ufkB5u
 btcTV9XgJnVpJ6kSXC2XxCLc6Oj4wYFiTRC2.TcWHhNIZvf2hsomgfFdqbW1
 AI7lebI4aB_WEsmgEJrJDqNH0.Q0vpfcQfB3mop77qHHq3Skbc7w9VT3QuNM
 J6zQApcoyEswrAWR0SfuIWdk-
X-Rocket-MIMEInfo: 001.001,PiBMZXQncyBzZWUsIGlmIEknbSByZWFkaW5nIHRoZSBsb2cgZmlsZSBjb3JyZWN0bHksIHRoZSBhdmVyYWdlIHZhbHVlcyBvZgoKPiBlYWNoIHRlc3QgcnVuIGRpZmZlciBieSB.IDAuMSBzZWNvbmRzIHRvcHMuCj4gCj4gRm9yIGV4YW1wbGUsIGk3LTM3NzBLIGdlbmVyaWMgYnVpbGQgZ2l2ZXMgb24gYXZlcmFnZSA2OS40MTQwNCB3aGlsZQo.IHRoZSBtb3JlIG9wdGltaXplZCB2ZXJzaW9uIDY5LjMzNTU0LiBUaGUgZGlmZiBiZXR3ZWVuIHRoZSB0d28gaXMgZXZlbgo.IGxlc3MgdGhhbiAwLjEgc2Vjb25kLiABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.128.478
References: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com> <20121205222738.GB6239@liondog.tnic> <1354748412.17691.YahooMailNeo@web140005.mail.bf1.yahoo.com> <20121205230835.GF6222@liondog.tnic> <1354968839.35825.YahooMailNeo@web140006.mail.bf1.yahoo.com> <20121209111857.GC24106@liondog.tnic>
Message-ID: <1355054935.13447.YahooMailNeo@web140004.mail.bf1.yahoo.com>
Date: Sun, 9 Dec 2012 04:08:55 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [PATCH] Expand CPU compiler options
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20121209111857.GC24106@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Let's see, if I'm reading the log file correctly, the average values of

> each test run differ by ~ 0.1 seconds tops.
> 
> For example, i7-3770K generic build gives on average 69.41404 while
> the more optimized version 69.33554. The diff between the two is even
> less than 0.1 second. The other two machines' diff is a bit higher. And
> from looking at your graphs, this is all eaten up by stddev so I'd say
> there aren't any improvements from using a different uarch target - just
> noise. AFAICT, at least.


While I agree that the differences as small - on the order of ms - they are not insignificant nor are they in the noise of the measurements.  
1) All the assumptions for ANOVA are met:
*Data are normally distributed as show in the normal quantile plots.

*The population variances are fairly equal (Levene and Barlett tests).

2) The ANOVA plots clearly show significance.
*Pair-wise analysis by Tukey-Kramer shows significance at the 0.05 level for all CPUs compared.  Below are the differences in median values:
core2 +87.5 ms
corei7-avx +79.7 ms
core-avx-i+257.2 ms

> In any case, these results are too marginal to warrant any code change
> since they're basically disappearing in noise.


Currently, the 'core2' optimization is included in as an option for a CPU Family.  In the case of core-avx-i, I am showing an improvement of ~3x over that.  And in the corei7-avx case, the improvement is approximately equal to it.  I don't understand why these wouldn't be considered value-added since they preform at least as good as the option already included.

Thank you for the consideration and suggestions.
