Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab0H3R6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:58:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33821 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab0H3R6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:58:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100829235100.6dcedcb8@debxo>
References: <20100628215407.2017bf2f@debian> <20100829235100.6dcedcb8@debxo>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 30 Aug 2010 11:58:22 -0600
X-Google-Sender-Auth: hs2p6PytkVjjSCY6A-peTN5BufU
Message-ID: <AANLkTikvVizX2jcnxgWOcJoewXR1hAE5SsEd9yzPF9Ys@mail.gmail.com>
Subject: Re: [PATCH 0/9] add OLPC device-tree support
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 9:51 PM, Andres Salomon <dilinger@queued.net> wrote:
> These patches modify drivers/of, sparc, and x86 accordingly to add
> OLPC device-tree support.  Updates have been made based upon Grant and
> Davem's comments.  They've been compile-tested on sparc64 and x86, and
> runtime tested on OLPC machines.
>
> Dave's 25edd6946 commit caused some conflicts w/ patch #2;
> hopefully I mangled it properly.

I've only looked through this code lightly, but it seems fairly sane,
other than issues already raised.  Since this has more impact on sparc
than anything, I'll need to have David's feedback before doing
anything with it.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
