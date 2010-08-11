Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0HKQkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:40:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48627 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0HKQkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UPb9SpWT6Eb3j+4jx6xEW4U9qfo5LtzBVNvJzKlRb3caACaYXDzQtVWVLiXOVdJNq4
         mlsPHbSN96sxpdKHDLuObV7PL5GrBALX8EksiKkNRF+MY8omY0rM2s0rx5azKHYZWt9C
         L6CfyFFTFSNN+sKHaAesOFJ4563U5lE/T8pKY=
MIME-Version: 1.0
In-Reply-To: <1281544234.5107.25.camel@localhost>
References: <4C5F9B25.8080401@st.com> <AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com> 
	<4C624AE1.30504@st.com> <4C62C5BD.3020808@mnsu.edu> <1281542305.5107.11.camel@localhost> 
	<AANLkTi=9xVdfXJXpkNPUMahc7AsbxjVbZFSxeBrzvbmS@mail.gmail.com> 
	<1281544234.5107.25.camel@localhost>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Wed, 11 Aug 2010 12:39:53 -0400
Message-ID: <AANLkTi=6hXj_a1X-HwYWvWt4_pBto_OQgkWE3VsDmEsJ@mail.gmail.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>,
        viresh kumar <viresh.kumar@st.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Valeo de Vries <valeo@valeo.co.cc>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>, mihai.dontu@gmail.com,
        richardcochran@gmail.com, "Gadiyar, Anand" <gadiyar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 12:30 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2010-08-11 at 12:18 -0400, Avery Pennarun wrote:
>> Out of curiosity, why fall back to one chunk at a time?  It seems to
>> me that IMAP should be able to still support multiple outstanding
>> requests in that case, but you'd just get errors on the latter chunks.
>>
>> It is just that there was no point optimizing the workaround case?
>
> There wasn't a lot of point in optimising it.

Say no more :)

I code on some IMAP clients occasionally and I just wanted to make
sure I wasn't missing something important.

Thanks!

Avery
