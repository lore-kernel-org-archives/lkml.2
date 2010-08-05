Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab0HEQec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:34:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35048 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab0HEQea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:34:30 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimMLts_x_BujsqYupkmA-UyB9mNyD6KZ0OeNRWd@mail.gmail.com>
References: <20100803114853.27a29365.sfr@canb.auug.org.au>
	<AANLkTimMLts_x_BujsqYupkmA-UyB9mNyD6KZ0OeNRWd@mail.gmail.com>
Date: Thu, 5 Aug 2010 09:34:29 -0700
Message-ID: <AANLkTikwweZdn4Uw9DabY7e1+Ed-ooA1-e7-0zNRgqmf@mail.gmail.com>
Subject: Re: linux-next: manual merge of the davinci tree with Linus' tree
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 9:30 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> On Mon, Aug 2, 2010 at 6:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Kevin,
>>
>> Today's linux-next merge of the davinci tree got a conflict in
>> arch/arm/mach-davinci/board-da850-evm.c between commit
>> 8b24599e72c9aee1ea1187e29cb9c5de9f449cce ("davinci: da850/omap-l138 evm:
>> account for DEFDCDC{2,3} being tied high") from Linus' tree and commit
>> ebd1e7808b2fe72d627bdab7bcf61126a831ca5a ("davinci: da850 evm: sparse
>> cleanup: make file local variables static") from the davinci tree.
>>
>> Just context changes.  I fixed it up (see below) and can carry the fix
>> for a while.
>
> Thanks for catching this.
>
> Before I submit to Linus, I'll merge this with the original tree
> (Liam's voltage-2.6 tree) so Linus doesn't have to fix this up.
>

On second thought, to keep it simple, I'm just going to drop the
version from the davinci tree for this merge window, update it and
submit it as a fix in -rc2.

Kevin
