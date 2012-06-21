Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab2FUPCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:02:50 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58978 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844Ab2FUPCt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Thu, 21 Jun 2012 11:02:49 -0400
Message-Id: <4FE353E0020000780008B263@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 21 Jun 2012 16:03:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-cris-kernel@axis.com>, <mingo@elte.hu>,
        "Ingo Molnar" <mingo@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/PCI: adjust section annotations
References: <4FDF2044020000780008A66F@nat28.tlf.novell.com>
 <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com>
 <4FE3040B020000780008B030@nat28.tlf.novell.com>
 <CAErSpo4Nc0RjwDEhwt=BLaKez2KRxVoVBc5EENG53VBMzgg67Q@mail.gmail.com>
 <4FE32E87.1020809@zytor.com>
In-Reply-To: <4FE32E87.1020809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.06.12 at 16:24, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 06/21/2012 07:19 AM, Bjorn Helgaas wrote:
>> 
>> OK.  Ingo, do you want to take this after all?
>> 
>> If I push stuff through my PCI tree, I try really hard to make PCI
>> overall more consistent, not less consistent, so I'm not very
>> interested in taking minor improvements to just one arch.
>> 
> 
> I can take this, but the above sounds very close to a NAK to me...

If that one hunk is causing so much grief, how about I resend
the whole patch with that one change dropped?

Jan

