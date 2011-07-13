Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1GMXCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:02:48 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.205]:41197 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab1GMXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:02:46 -0400
Message-ID: <4E1E23E6.1020706@interia.pl>
Date: Thu, 14 Jul 2011 00:01:58 +0100
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628
	Thunderbird/5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] e_powersaver: Add sanity checks to code provided by VIA
References: <1310114243.2940.3.camel@phoenix> <4E1B745A.5000802@interia.pl>
	<20110713222428.GB14071@redhat.com>
In-Reply-To: <20110713222428.GB14071@redhat.com>
X-Interia-Antivirus: OK
X-EMID: 8cf58958
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, Jul 11, 2011 at 11:08:26PM +0100, Rafał Bilski wrote:
>   >  Patch from VIA is forcing "e_powersaver" to accept any processor
>   >  >=A, but code supports only A and D.
>   >  Patch from VIA is forcing "e_powersaver" to support new brand, but
>   >  code was intended for 2 bits only.
>   >  Looks like model D is using 8 bits for brand. Compensate.
>   >
>   >  Thanks to Axel Lin for pointing it out!
>   >
>   >  Signed-off-by: Rafał Bilski<rafalbilski@interia.pl>
>
> This, and your other patch still don't apply, because your email client
> has converted all tabs to spaces.
>
> 	Dave
>
Sorry. I was sure in past I used Mozilla Thunderbird to send patches.
I will resend patches tomorrow. Second patch seems a bit premature now
anyway. Do you mind if I shorten message to: CPU isn't running at max
frequency (as I expected), you can use option to...?

Sorry
Rafał


----------------------------------------------------------------
Znajdz samochod idealny dla siebie!
Szukaj >> http://linkint.pl/f29e2
