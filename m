Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab0EZLXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:23:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47792 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0EZLXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:23:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nUw6ZwaUAQ/EMVpmMtcmGD/d1+XJawObvTg4BpZqO7LkfhGsYR1Jk2b4D1132v+CR4
         9bfuVqMv+GBqQkftNCzdvQ6aOTPepc5akz4cfdc+TdCAEVcFEgYPnAPqVBuvfhf75knl
         1gKr6iQog8mWGeyYPSNSXhslWDKU0ghSQbJW8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinlxsokwralwRAL9_YRQ7-SZUSvrGHTlRISA9bC@mail.gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<AANLkTiksR3YozbBH0Iv5kNsQkEGKCH1APCvn_s6LkjV9@mail.gmail.com>
	<1274868593.5882.5185.camel@twins>
	<AANLkTinuxCbeBmxIR7b_1OtrqQYJCamiDZJbnNTih1Fb@mail.gmail.com>
	<1274869966.5882.5262.camel@twins>
	<AANLkTikRMBkoFxgaKsxMJ2lOMomTXpiHJDk3rVt0EtwM@mail.gmail.com>
	<1274870970.5882.5311.camel@twins>
	<AANLkTinlxsokwralwRAL9_YRQ7-SZUSvrGHTlRISA9bC@mail.gmail.com>
Date: Wed, 26 May 2010 13:23:14 +0200
Message-ID: <AANLkTinNY1vtXpjzPpdBYiI5fbz9Dp50YOpZSfHdoN_D@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Vitaly Wool <vitalywool@gmail.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Arve Hjønnevåg <arve@android.com>:

> Fixing the actually issue means fixing all user-space code, and
> replacing most x86 hardware. I don't think keeping this feature out of
> the kernel will significantly accelerate this.

But if this feature gets merged, I bet you'll find another 100 reasons
to not fix the actual issue. I wouldn't say so if you haven't provided
the irrelevant points already, like "replacing x86 hardware". You're
trying to merge the approach which makes the bad way of handing things
the easiest way. This shouldn't get in as it is IMO.

~Vitaly
