Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1HDLQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:16:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39422 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1HDLQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:16:19 -0400
Date: Thu, 4 Aug 2011 15:16:13 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Richard Weinberger <richard@nod.at>,
        serge.hallyn@canonical.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: shm updates broke UML
Message-ID: <20110804111613.GA2375@albatros>
References: <201108011541.59640.richard@nod.at>
 <08cf4697685ecd9bcb7e4eefe516f2ee@localhost>
 <20110801172452.GA26190@albatros>
 <201108041304.41135.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108041304.41135.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 13:04 +0200, Toralf Förster wrote:
> issue solved for the UML, tested linux-v3.0-7347-g288d5ab whcih works fine.
> 
> BTW is there a special commit id dealing with this bug or was it solved as a 
> side effect of another commit ?

The oops is fixed by 298507d4d2cff2248e84afcf646b697301294442 (shm:
optimize exit_shm()), but the dependency problem (tasks spawned by the
kernel are started with uninitialized namespaces) is not solved yet,
AFAICS.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
