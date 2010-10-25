Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0JYP4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:56:37 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:29854 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756278Ab0JYP4g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:56:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=UFbcCnqMl8R0abWcs3/vPW1UeTrMQchzRgYtfsoz3Hy0K6qycH8HPdYBcPTIxNI95oUIEQ3+7msWXcz0R6a2Kbklln27QcKwi3vLMXWbxAhSUAdUrXbZAFakBeNbqQT1v6VqyEKMZScvzeRQBgLtsZtSuj3iU9IfNlcPEMEE6ic=;
Message-ID: <555825.15477.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: oeZhiA4VM1mv0JTWYasbcTvy7Xyzf5PkvUrC7.5VZq9Dqop
 GfUPNk4fmXje1atmN5K6SRTMbuXsRWJboL3SzE8jm.JbdtkBOF_e7KCFt_en
 r9p0Uxyd1TFbRplbkIi8HnNXzaB7wMxexvXzQdwROoCAhyDSqdiM6SoEMD1p
 85P5SvHJLMEmQrhm4Q8zMTJyFm1nUWeSfGnHIt8Gvgownb15nAaXzW44RIcv
 2_OoTC.dDwreRijdqSmgEwweh1fHiq5MIhlB0sq_7lR2rQh8mOopT7hoeuqG
 mRFdxxq4HuluLUjF7WtGnc35u8AlxNjuRDCuXTPPAtQrn12n6Y8pYuV5BSzp
 r3X4rTS4JIW7zF5gnQBD4ug--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:56:34 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 15/29] memstick: jmb38x_ms: Create header
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-16-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 15/29] memstick: jmb38x_ms: Create header
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> In the new header add:
> 
> * debug macros
> * Registers + some documntation
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---

Yet again, what's wrong with DYNAMIC_DEBUG?



      
