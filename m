Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2DANd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:33:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37323 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2DANdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:33:55 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Extend core dump note section to contain file names of mapped files
Date: Sun, 1 Apr 2012 15:33:51 +0200
User-Agent: KMail/1.8.2
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
References: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com> <20120401031329.GP17822@one.firstfloor.org>
In-Reply-To: <20120401031329.GP17822@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204011533.51628.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2012 05:13, Andi Kleen wrote:
> > I propose to save this information in core dump, as a new note
> > in note segment.
> 
> Seems like a good idea but rather than write complicated code i would just reuse
> the /proc/*/maps code and dump it in that format?

I looked at this code (it's in fs/proc/task_mmu.c).

It uses seq_printf(). It will need refactoring if we would
want to use it for purposes other than /proc pseudo-file
generation.

-- 
vda
