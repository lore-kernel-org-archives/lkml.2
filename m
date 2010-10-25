Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0JYROy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:14:54 -0400
Received: from mxout1.idt.com ([157.165.5.25]:38114 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759149Ab0JYROx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:14:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Date: Mon, 25 Oct 2010 10:13:38 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D5C2@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4CC5ACAB.7070309@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Thread-Index: Act0X5uu0jB8BdzdSzKgJzfhF6R8ygAAFO3w
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com> <4CC1D7DE.7060405@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445A6B@CORPEXCH1.na.ads.idt.com> <4CC20923.8050400@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445BA4@CORPEXCH1.na.ads.idt.com> <4CC5ACAB.7070309@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen <micha@neli.hopto.org> wrote:
> 
> Bounine, Alexandre wrote:
> > 1. The destid for the switch needs an additional mechanism to share
it
> > among processors in the RIO network,
> 
> ? See comment for 2)
> 
> > 2. It takes ID value away from the pool of available IDs, what will
> 
> It does not take an ID away, it shares it with a connected endpoint to
> that switch. The tag uses one extra bit to identify the device as a
> switch instead of an endpoint. This provides the information to
> unambiguously identify a switch from an endpoint.

OK taking away #2. But do not see how it justifies storing two values of
destid.

And you have just confirmed using CT for unique identification. We
simply have differences in interpretation of CT: you are using component
tag to pass unique identification and I am using CT as a unique
identification. I prefer not to assume any relationship between routing
information and the component tag.

Alex.


