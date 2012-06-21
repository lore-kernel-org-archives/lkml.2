Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2FUPyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:54:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59137 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab2FUPxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:53:42 -0400
MIME-Version: 1.0
In-Reply-To: <4FE353E0020000780008B263@nat28.tlf.novell.com>
References: <4FDF2044020000780008A66F@nat28.tlf.novell.com>
 <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com>
 <4FE3040B020000780008B030@nat28.tlf.novell.com> <CAErSpo4Nc0RjwDEhwt=BLaKez2KRxVoVBc5EENG53VBMzgg67Q@mail.gmail.com>
 <4FE32E87.1020809@zytor.com> <4FE353E0020000780008B263@nat28.tlf.novell.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 21 Jun 2012 09:53:20 -0600
Message-ID: <CAErSpo5-UcvYGTX66REMf--QNdv0kyhmTgp3vyG39GOQQUJ=Lg@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: adjust section annotations
To: Jan Beulich <JBeulich@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-cris-kernel@axis.com,
        mingo@elte.hu, Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 9:03 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 21.06.12 at 16:24, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> On 06/21/2012 07:19 AM, Bjorn Helgaas wrote:
>>>
>>> OK.  Ingo, do you want to take this after all?
>>>
>>> If I push stuff through my PCI tree, I try really hard to make PCI
>>> overall more consistent, not less consistent, so I'm not very
>>> interested in taking minor improvements to just one arch.
>>>
>>
>> I can take this, but the above sounds very close to a NAK to me...
>
> If that one hunk is causing so much grief, how about I resend
> the whole patch with that one change dropped?

I'm sorry, I didn't handle this very well.  I'm afraid it sounded as
if I were faulting you for not doing more, but that's not it.
Suggesting the pcibios_setup() change was valuable because reviewing
it uncovered a bug and a nice cleanup opportunity, so thank you for
that!

My *intent*, in this as in other cases, is just to encourage folks to
step back from "solving my immediate problem" and take a broader view
that includes "does this same problem occur other places?" and "how
can I leverage this point solution to make things a bit cleaner for
everybody?"

In the time I've spent on this email thread, I could have done the
whole cleanup myself, but in the long term, I think it's important to
encourage an attitude of preserving and improving the commons.  Maybe
the fact that I'd rather deal with more general solutions will
encourage employers to support that kind of work, or at least give
people more ammunition when they management to support it.  That's my
hope, anyway :)

Bjorn
