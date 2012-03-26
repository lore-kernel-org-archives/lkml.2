Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2CZK11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:27:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63499 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667Ab2CZK10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:27:26 -0400
Date: Mon, 26 Mar 2012 13:27:11 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] tools: Add a toplevel Makefile
In-Reply-To: <alpine.DEB.2.00.1203221646450.32581@router.home>
Message-ID: <alpine.LFD.2.02.1203261326310.7116@tux.localdomain>
References: <1332435713-32143-1-git-send-email-bp@amd64.org> <1332435713-32143-3-git-send-email-bp@amd64.org> <alpine.DEB.2.00.1203221332390.25011@router.home> <20120322210431.GA1462@aftab> <alpine.DEB.2.00.1203221646450.32581@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Christoph Lameter wrote:
> On Thu, 22 Mar 2012, Borislav Petkov wrote:
> 
> > It basically does:
> >
> > $ make -C slub/ clean
> >
> > which runs the target of the same name in the Makefile in slub/.
> 
> Ok.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Didn't Andrew already patches that moved this under tools/vm and added 
proper Makefiles for it?
