Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0JZCA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:00:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47388 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0JZCA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q/VK20ZPNgXBeHKDTBt9BGEUs92LFpXJiAR1DuZqhPYL1InWo/Bdev5TEY7u8h43+L
         2V4thytKHD0GNos4ZB5DTpckPFBK/xzihOd0AOKcEla5SQoo9//Pz8lKPZ3JPhoCtgZt
         xNNyTJk1ISIbxOuEcQBBGdtmtvQ1qpWNasNtA=
Subject: Re: [PATCH 11/29] memstick: mspro: use MS_TPC_EX_SET_CMD
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <518013.36245.qm@web37604.mail.mud.yahoo.com>
References: <518013.36245.qm@web37604.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:00:22 +0200
Message-ID: <1288058422.4024.122.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:27 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 11/29] memstick: mspro: use MS_TPC_EX_SET_CMD
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > This little optimization done by Sony
> > for
> > PRO variant of the cards allows to bundle the param
> > register
> > with the command and therefore send one TPC less.
> > 
> > This increases IO throughput somewhat.
> > (4.4 -> 4.8 MB/s on Jmicron for example)
> > 
> 
> 1. Names for states.
> 2. Coding style.
Already said that many times.
It passes checkpatch.pl. 


> 3. Introduction of struct mspro_cmdex_argument belongs to this patch.
I won't fight over that one, but I think that its doesn't matter.


Best regards,
	Maxim Levitsky

