Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0KHVBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:01:18 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:54551 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0KHVBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:01:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=SUgaBu
	EpB6vuGmX5+fe/FJvFMtMrEEyCSBSLNNR7CU3mTEXzBweQkThJ0WthVMGTe3nWwx
	5qMmUaYcMpJT0IPnGKnoaZBMrNNWs+Spo2MRm+MBZnGp2JW7vrvS4Jwaa+Sw1fY3
	t2bDMQwfYDznQKvNU1CVB3jsMHculK7uN3e9M=
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Nathan Lynch <ntl@pobox.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 15:01:04 -0600
Message-ID: <1289250064.24462.42.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 527A2D0E-EB7B-11DF-8555-B53272ABC92C-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mon, 2010-11-08 at 11:55 -0500, Grant Likely wrote:
> Also:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 9458685..335a4b3 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -93,6 +93,10 @@ config STACKTRACE_SUPPORT
> >  config HAVE_LATENCYTOP_SUPPORT
> >        def_bool y
> >
> > +config CHECKPOINT_SUPPORT
> > +       bool
> > +       default y
> > +
> 
> Definitely should not default to 'y', and needs to be user-selectable.

CHECKPOINT_SUPPORT is what an arch sets to indicate that it has support
for C/R -- the user selectable option is in a generic location (and
defaults to n).


