Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab0KZUeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 15:34:46 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33204 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0KZUep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 15:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=AxPCRRnIj7PSuGTmGubSPkivfWouJ+ftlYWrSloMUP1tL7deOWAbeiOiVTzmZQzOkx
         IQ1p1oDBfh6i4x1wZ5CTHm78D+ciZb2MV6SXQ/ySNFVuTsSIJOnCUZxwAbo/TmZ37wc7
         hOlRKa5iz4GwQrK7B6u+X1tGAaylrPVoV3k4A=
MIME-Version: 1.0
In-Reply-To: <4CEFC1AA0200007800024734@vpn.id2.novell.com>
References: <4CEFC1AA0200007800024734@vpn.id2.novell.com>
Date: Fri, 26 Nov 2010 20:34:44 +0000
X-Google-Sender-Auth: Vq9X5i7d3x2MqnESJ0OlxKf-h-k
Message-ID: <AANLkTi=Kn+dAc9uUFnUCRA35CyHQZgrwzcM_P-Hc8XOC@mail.gmail.com>
Subject: Re: your patch "x86, olpc: Rework BIOS signature check"
From: Daniel Drake <dsd@laptop.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On 26 November 2010 13:18, Jan Beulich <JBeulich@novell.com> wrote:
> ... adds a select of OLPC_OPENFIRMWARE to the OLPC option,
> which contradicts OLPC_OPENFIRMWARE itself depending on
> !X86_64 && !X86_PAE. Are the latter dependencies not necessary
> anymore (the X86_64 one wasn't very meaningful anyway, since
> these options all sit inside a "if X86_32"), or should the select be
> conditional?
>
> Also, how meaningful is having OLPC_OPENFIRMWARE on but OLPC
> off (i.e. can OLPC_OPENFIRMWARE perhaps go away altogether)?

Yeah, having reached this point we think OLPC_OPENFIRMWARE should be
merged into CONFIG_OLPC. I'll submit a patch soon.

Daniel
