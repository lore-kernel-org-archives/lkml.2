Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0ETT47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:56:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50476 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0ETT45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ffu1xSISbf3cEP9W1SJdSy/3d7rGG4rKBK76DI3OXC6e0hAOOB8XyhMuOyHwasQzM0
         ouueDdna5FzNj+KufSuh/T5EMxbXwndcZO/GI70Y9XgWci4/bQCtFP2iEruKhJTy7qp5
         EIUONGg0UjJqVYUBwAI8HydWBapXbiAHbpTDM=
MIME-Version: 1.0
In-Reply-To: <20100520183701.GW26248@jirafa.cyrius.com>
References: <4BF33CAD.2070602@zytor.com> <871vd8xb8t.fsf@basil.nowhere.org>
	 <20100520183701.GW26248@jirafa.cyrius.com>
Date: Thu, 20 May 2010 21:56:56 +0200
Message-ID: <AANLkTikB9Fcyrp-_8XqOWhrxXS1aOVFQRfbzv0vBUQQR@mail.gmail.com>
Subject: Re: Does anyone care about gcc 3.x support for *x86* anymore?
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 8:37 PM, Martin Michlmayr <tbm@cyrius.com> wrote:
> * Andi Kleen <andi@firstfloor.org> [2010-05-19 15:38]:
>> > If there isn't a reason to preserve support, I would like to consider
>> > discontinue support for using gcc 3 to compile x86 kernels.  If there is
>> > a valid use case, it would be good to know what it is.
>>
>> I suspect there are still distributions around that use it as a standard
>> compiler. Wasn't it used in some major release of Debian?
>
> Not in a recent one, no.

Not even in oldstable (etch).

> --
> Martin Michlmayr
> http://www.cyrius.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
