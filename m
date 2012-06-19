Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2FSEaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 00:30:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44158 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2FSEaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 00:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120619000150.GA4208@kroah.com>
References: <1339940861-18258-1-git-send-email-devendra.aaru@gmail.com>
	<20120619000150.GA4208@kroah.com>
Date: Tue, 19 Jun 2012 10:00:15 +0530
Message-ID: <CAHdPZaOPB_ruWGTa7vid9+_P_GiSQC02J=Q5e=2us7NGrCVKiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging/rtl8192u: cleanup coding style problems
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for spending your valuable time in reviewing the patch,

On Tue, Jun 19, 2012 at 5:31 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Jun 17, 2012 at 07:17:40PM +0530, Devendra Naga wrote:
>> The following warnings / errors were cleaned
>>
>> drivers/staging/rtl8192u/r8180_93cx6.c:25: ERROR: space required before the open parenthesis '('
>> drivers/staging/rtl8192u/r8180_93cx6.c:28: ERROR: do not use C99 // comments
>> drivers/staging/rtl8192u/r8180_93cx6.c:30: WARNING: line over 80 characters
>> drivers/staging/rtl8192u/r8180_93cx6.c:31: ERROR: do not use C99 // comments
>> drivers/staging/rtl8192u/r8180_93cx6.c:41: ERROR: space required after that ',' (ctx:VxV)
>> drivers/staging/rtl8192u/r8180_93cx6.c:45: ERROR: need consistent spacing a round '&' (ctx:WxO)
>> drivers/staging/rtl8192u/r8180_93cx6.c:45: ERROR: space prohibited after that '~' (ctx:OxW)
>> drivers/staging/rtl8192u/r8180_93cx6.c:51: ERROR: space required after that ',' (ctx:VxV)
>> drivers/staging/rtl8192u/r8180_93cx6.c:53: ERROR: space required before the open parenthesis '('
>> drivers/staging/rtl8192u/r8180_93cx6.c:55: ERROR: space required after that ',' (ctx:VxV)
>> drivers/staging/rtl8192u/r8180_93cx6.c:57: ERROR: space required after that ',' (ctx:VxV)
>> drivers/staging/rtl8192u/r8180_93cx6.c:69: ERROR: spaces required around that '=' (ctx:VxV)
>> drivers/staging/rtl8192u/r8180_93cx6.c:69: ERROR: space prohibited before that close parenthesis ')'
>> drivers/staging/rtl8192u/r8180_93cx6.c:72: ERROR: space required before the open parenthesis '('
>> drivers/staging/rtl8192u/r8180_93cx6.c:72: ERROR: trailing statements should be on next line
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>
> It's good you broke this down as to what you were fixing, but I don't
> like this change:
>
>> -     if(bit) return 1;
>> -     return 0;
>> +     return bit ? 1: 0;
>
> Please don't use ? : if you can help it, it is just hard to read.
Ok.
>
> Care to redo this one and resend both patches?
>
You can expect a V2 of your comments :-),
and the second patch will be broken into little more pieces.
> thanks,
>
> greg k-h
