Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab2FUOYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:24:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49863 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758622Ab2FUOYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:24:42 -0400
Message-ID: <4FE32E87.1020809@zytor.com>
Date: Thu, 21 Jun 2012 07:24:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        linux-cris-kernel@axis.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: adjust section annotations
References: <4FDF2044020000780008A66F@nat28.tlf.novell.com> <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com> <4FE3040B020000780008B030@nat28.tlf.novell.com> <CAErSpo4Nc0RjwDEhwt=BLaKez2KRxVoVBc5EENG53VBMzgg67Q@mail.gmail.com>
In-Reply-To: <CAErSpo4Nc0RjwDEhwt=BLaKez2KRxVoVBc5EENG53VBMzgg67Q@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 07:19 AM, Bjorn Helgaas wrote:
> 
> OK.  Ingo, do you want to take this after all?
> 
> If I push stuff through my PCI tree, I try really hard to make PCI
> overall more consistent, not less consistent, so I'm not very
> interested in taking minor improvements to just one arch.
> 

I can take this, but the above sounds very close to a NAK to me...

	-hpa


