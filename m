Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1ENRsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 13:48:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753Ab1ENRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 13:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110514102804.GB23665@htj.dyndns.org>
References: <201105120025.34531.rjw@sisk.pl> <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com>
 <201105132222.11582.rjw@sisk.pl> <201105132244.29605.rjw@sisk.pl>
 <20110514101807.GA23665@htj.dyndns.org> <20110514102804.GB23665@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 May 2011 10:47:44 -0700
Message-ID: <BANLkTi=BNu8mdafPVtbqbKpK4ZcjDDR=YQ@mail.gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant
 to AHCI spec"
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jian Peng <jipeng2005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 3:28 AM, Tejun Heo <tj@kernel.org> wrote:
>
> As we're already in -rc7, I'm sending the revert patch to both Jeff
> and Linus.

Applied,

                   Linus
