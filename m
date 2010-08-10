Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab0HJTMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:12:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48036 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab0HJTMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VL5RdoIvelJYQGbJE3bTcq4fNKEZ3zFbj6JMgC5/qFWC+G8q4KYra34+2smDAi8GmL
         DgByTJ/YWjtZE9dwv109DJw0aoJXZ3nvcUJKHz6d9rce01nvSm+p3YkiQkyRtHFLrvPT
         f/DG60eYtPvNybSGHSiIZB/pAm9IEb/CYSUjE=
MIME-Version: 1.0
In-Reply-To: <1281460072.16880.47.camel@e102109-lin.cambridge.arm.com>
References: <20100421192319.GA16719@debian>
	<1281460072.16880.47.camel@e102109-lin.cambridge.arm.com>
Date: Wed, 11 Aug 2010 00:41:59 +0530
X-Google-Sender-Auth: Ue8Kj7-En6lm_pXE4_aL_MmXMlY
Message-ID: <AANLkTi=Vf6NPxDqpL8ycpjXDNajTzdYVXFYdLq0CxJZ8@mail.gmail.com>
Subject: Re: [PATCH 05/10] ARM: ftrace: add ENDPROC annotations
From: Rabin Vincent <rabin@rab.in>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Abhishek Sagar <sagar.abhishek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Tue, Aug 10, 2010 at 10:37 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Wed, 2010-04-21 at 20:23 +0100, Rabin Vincent wrote:
>> When building as Thumb-2, the ".type foo, %function" annotation in
>> ENDPROC seems to be required in order for the assembly routines to be
>> recognized as Thumb-2 code.  If the ENDPROC annotations are not present,
>> calls to these routines are generated as BLX instead of BL.
>>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Rabin Vincent <rabin@rab.in>
>
> What's the status of these patches? I haven't seen them in mainline.

They're in the patch tracker now.  I'd forgotten about them for a while,
and there was one patch missing an ack, but that's sorted out now.

Rabin
