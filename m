Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1EKTbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:31:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab1EKTbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:31:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the suspend tree with the mips tree
Date: Wed, 11 May 2011 21:31:58 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>
References: <20110511130618.581a89a3.sfr@canb.auug.org.au>
In-Reply-To: <20110511130618.581a89a3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112131.59135.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 11, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the suspend tree got a conflict in
> arch/mips/alchemy/common/dbdma.c between commit 02810a022fd9 ("MIPS:
> Alchemy: Convert dbdma.c to syscore_ops") from the mips tree and commit
> 4d0fb1376519 ("PM / MIPS: Use struct syscore_ops instead of sysdevs for
> PM (v2)") from the suspend tree.
> 
> These seem to be trying to do the same thing.  I used the version from
> the mips tree for now.  Please sort this out ...

OK, I will drop the MIPS chanages from my tree.

Thanks,
Rafael
