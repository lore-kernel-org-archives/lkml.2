Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab1GRLDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 07:03:02 -0400
Received: from mail.southpole.se ([193.12.106.18]:56624 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1GRLC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 07:02:59 -0400
Subject: Re: linux-next: manual merge of the akpm tree with the openrisc
 tree
From: Jonas Bonn <jonas@southpole.se>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
In-Reply-To: <20110718185608.97377aa900b014aa010830a2@canb.auug.org.au>
References: <20110718185608.97377aa900b014aa010830a2@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Mon, 18 Jul 2011 13:02:55 +0200
Message-ID: <1310986975.21015.13.camel@needafix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2011-07-18 at 18:56 +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the scsi-post-merge tree got a conflict in
> arch/x86/include/asm/delay.h between commit 10f53642f115 ("asm-generic:
> move archictures to common delay.h") from the openrisc tree and commit
> "With a non-constant 8-bit argument, a call to udelay() generates a
> warning:" from the akpm tree.
> 
> I just dropped this patch from the akpm tree as the former commit
> consolidated this code into asm-generic/delay.h (which doesn't solve the
> problem).

Applying the change from Andrew's patch to asm-generic/delay.h looks
like the sane thing to do.  I can do that in my tree and then Andrew can
drop the patch from his tree... does that sound reasonable?

Just so others don't have to go digging for it, the patch in question
is:

http://userweb.kernel.org/~akpm/mmotm/broken-out/arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch

/Jonas

