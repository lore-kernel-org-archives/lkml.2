Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0ERXWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:22:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57778 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0ERXWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Dj+VTUezFo1sKJpaa21Ex0PdpKnBOcNDjI54v8F2L8XXpRWFkIYHTU/5L1j5jRWbWN
         fghdsixGxd9e4ikJfbuHN2gvGZ4WKGVFkpMcQm2Y6dcHj50Zh6ptu3UQ0GQpLVhN/+wG
         elUgTpBVlWXQO28BLPX7oIeEZhDRBuWl952Qs=
MIME-Version: 1.0
In-Reply-To: <20100518084551.GA22675@basil.fritz.box>
References: <4B32565E.6000501@compro.net> <4B3270FE.5090607@compro.net>
	 <1261600243.16916.56.camel@localhost.localdomain>
	 <4B476E8D.1030308@compro.net>
	 <20100121190952.GA32523@linux-os.sc.intel.com>
	 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
	 <20100125171059.GB5041@alberich.amd.com>
	 <20100517145943.GV5888@alberich.amd.com> <4BF1E5BE.9010000@gmail.com>
	 <20100518084551.GA22675@basil.fritz.box>
Date: Tue, 18 May 2010 17:22:38 -0600
Message-ID: <AANLkTilaO0yzg1IzdrnND6kvw539Kpz6Alaa30QMj8pc@mail.gmail.com>
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
From: Robert Hancock <hancockrwd@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       markh@compro.net, dmarkh@cfl.rr.com,
       Linus Torvalds <torvalds@linux-foundation.org>, alain@knaff.lu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 2:45 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> If one wanted, you could disable HPET MSI on this chipset only when a
>> driver requests an ISA DMA channel. Then if there's no floppy or other LPC
>> DMA device present, it can stay enabled. I don't know if it's worth the
>> trouble, though.
>
> There can be LPC devices which are not visible to the kernel,
> but only used through ACPI or the BIOS. Think of fancy fan
> controllers and similar.

I would hope they wouldn't use DMA without kernel knowledge, otherwise
that really would be an abomination..
