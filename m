Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0HDSdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:33:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754029Ab0HDSdR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <20100804015530.GA8136@havoc.gtf.org>
References: <20100804015530.GA8136@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Aug 2010 11:32:05 -0700
Message-ID: <AANLkTik-68XiTq3VC6ta3-YVL8r=FpwFErAx8nVV4CJ4@mail.gmail.com>
Subject: Re: [git patches] libata updates
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 6:55 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Tejun Heo (4):
>      ata_generic: drop hard coded DMA force logic for CENATEK
>      ata_piix: fix locking around SIDPR access
>      libata: more PCI IDs for jmicron controllers
>      sata_fsl,mv,nv: prepare for NCQ command completion update

Hmm. Aren't these the ones that you said causes "sata_mv is behaving
weirdly"? I think I'll wait for you to do another pull request when
that is sorted out..

             Linus
