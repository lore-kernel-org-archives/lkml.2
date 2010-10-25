Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab0JYQNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:13:35 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:52163 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab0JYQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:13:34 -0400
Message-ID: <4CC5ACAB.7070309@neli.hopto.org>
Date: Mon, 25 Oct 2010 18:13:31 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com> <4CC1D7DE.7060405@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445A6B@CORPEXCH1.na.ads.idt.com> <4CC20923.8050400@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445BA4@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55201445BA4@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> Micha Nelissen <micha@neli.hopto.org> wrote:
>>> rid of rswitch->switchid and use component_tag directly for
> switches).
>> I still prefer the destid as the single identification id.
> 
> In your patch you allocate individual destid for switches. This method
> has two problems:
> 1. The destid for the switch needs an additional mechanism to share it
> among processors in the RIO network,

? See comment for 2)

> 2. It takes ID value away from the pool of available IDs, what will

It does not take an ID away, it shares it with a connected endpoint to 
that switch. The tag uses one extra bit to identify the device as a 
switch instead of an endpoint. This provides the information to 
unambiguously identify a switch from an endpoint.

Micha
