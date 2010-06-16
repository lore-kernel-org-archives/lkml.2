Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab0FPKro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771Ab0FPKrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:47:43 -0400
Message-ID: <4C18AB9F.2020305@redhat.com>
Date: Wed, 16 Jun 2010 12:46:55 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Christoph Hellwig <hch@lst.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: remove CONFIG_4KSTACKS
References: <20100616091621.GA4486@lst.de> <20100616112136.42ab08ef@lxorguk.ukuu.org.uk> <20100616102051.GA7731@lst.de> <20100616102307.GU20317@bombadil.infradead.org>
In-Reply-To: <20100616102307.GU20317@bombadil.infradead.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 12:23 PM, Kyle McMartin wrote:
> On Wed, Jun 16, 2010 at 12:20:51PM +0200, Christoph Hellwig wrote:
>>> Perhaps XFS should select 8K stack instead ?
>>
>> or rather !CONFIG_INSANE.  I don't care too much.  No one sane should
>> ever enable it anymore, but Ingo asked me to send a patch to remove it.
>>
> 
> Alan--
> 
> It's not just XFS, we were regularly seeing blown stacks on Fedora with
> ext3/4 and encrypted disks using dm-crypt...

Can you point me to report where 4k stacks is not enough for plain dm-crypt?
IIRC it was always XFS (maybe ext4) on top of it what caused problem...

(Anyway, removing 4k stacks is probably good thing:-)

Milan
