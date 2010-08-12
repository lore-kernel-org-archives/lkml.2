Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab0HLEmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 00:42:09 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:55609 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab0HLEmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 00:42:06 -0400
Message-ID: <4C637B63.1060404@st.com>
Date: Thu, 12 Aug 2010 10:11:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Valeo de Vries <valeo@valeo.co.cc>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>,
        "mihai.dontu@gmail.com" <mihai.dontu@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com> <4C624AE1.30504@st.com> <4C62C5BD.3020808@mnsu.edu>
In-Reply-To: <4C62C5BD.3020808@mnsu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 8/11/2010 9:16 PM, Jeffrey Hundstad wrote:
> Hello,
>
> Exchange 2010 does not handle IMAP "chunking" (partial message transfer) 
> correctly.  Any request after about 1 megabyte of total message size 
> will fail.
>
> Thunderbird uses this "chunking" feature to give you a status update 
> while downloading large messages.  The IMAP statements are of this type:
> 11 UID fetch 244477 (UID RFC822.SIZE BODY[]<20480.12288>)
>
> When the 20480 is larger than 1MB Exchange "claims" there is no more.  
> Sigh....
>
> Fortunately you can disable this feature.  To disable this in 
> Thunderbird you can go to the Advanced configuration and disable the 
> following feature, by setting it to false:
> mail.server.default.fetch_by_chunks
Jeffrey,

I tried this but problem is still there.

viresh.
