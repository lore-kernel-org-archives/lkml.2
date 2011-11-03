Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1KCRl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab1KCRl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:41:56 -0400
Message-ID: <4EB2D260.7070807@redhat.com>
Date: Thu, 03 Nov 2011 15:41:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Josh Boyer <jwboyer@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sb_edac 32-bit compile fail due to 64-bit divide
References: <20111103140716.GF19809@zod.bos.redhat.com> <4EB2A5FF.1040808@redhat.com> <20111103144347.GG19809@zod.bos.redhat.com> <987664A83D2D224EAE907B061CE93D5301F566BB32@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301F566BB32@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-11-2011 14:31, Luck, Tony escreveu:
>>> Of course, an interim fix would be to make it depend on CONFIG_64BIT or CONFIG_X86_64.
>>
>> That would work I guess.  It's up to you.
> 
> Typically the test platforms I get have pretty much the minimum sane memory
> configuration - my Sandy Bridge EP machine came with 32GB of memory (which
> is theoretically bootable with a 32-bit kernel, but really isn't going to
> be much fun to use).  So I would think that time could be spent on more
> productive things than making this edac driver work on 32-bit.  My vote
> is for the "depends on 64-bit" solution.

Works for me. It would be a trivial patch. We can later fix it for 32 bits, if
someone has any usage for it with 32 bits kernels.

Thanks,
Mauro.
