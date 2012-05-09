Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab2EIG1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:27:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41698 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab2EIG1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:27:38 -0400
Date: Wed, 9 May 2012 09:27:28 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anbu Manikandan <canbumanikandan@gmail.com>
cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: Kmemleak feature
In-Reply-To: <CAAGB47N3oPkK1WhwzB7q4_6rvzKbnx3Ugwdr+aUuwTqiNX2oog@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1205090925420.1879@tux.localdomain>
References: <CAAGB47OajENL-g-CvdAgp1k2XKU4dOWbHz=mDy79mPOvi-eEmQ@mail.gmail.com> <CAAGB47PiZ0cveWvObEjS8OPB++M3s1dENybnjoxyhQ8K_T4SpA@mail.gmail.com> <CAAGB47PmB8o=mrnSoU1jYt_ecjH2WBLEzGRFqZWhWZXWQkTHaA@mail.gmail.com> <CAAGB47PpTx9-eFz6ppbCYshA5yp293Tm1X-cAaBkZ+xX05_UUg@mail.gmail.com>
 <CAAGB47N3oPkK1WhwzB7q4_6rvzKbnx3Ugwdr+aUuwTqiNX2oog@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Anbu Manikandan wrote:
> I am very much interested in learning about kmemleak feature in linux
> 3.0-RT kernel.
> I have already read the kmemleak document (Documentation/kmemleak.txt)
> provided in the kernel source.
> 
> Furthermore, I would like to understand the internal functionality of
> kmemleak source code.
> Could you please share some documents, links or presentations to
> understand the kmemleak internal functionality?

Catalin is the main author of kmemleak. I'm not aware of such 
presentations.

> One more thing, I have tried kmemleak test module in an ARM Target
> board(CortexA9 SMP Dual core Board) with 3.0-RT kernel and found that
> memory leak entries are not properly shown in
> sys/kernel/debug/kmemleak file.
> Instead of getting 25 memory leak entries in
> /sys/kernel/debug/kmemleak file, I have got only 5 memory leaks
> entries.
> May be the other memory leaks are called as false negatives as per the
> kmemleak document.
> Please suggest some way to overcome this problem.

I'm CC'ing LKML.

			Pekka
