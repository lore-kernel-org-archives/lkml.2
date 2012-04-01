Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2DADNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 23:13:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59183 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2DADNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 23:13:34 -0400
Date: Sun, 1 Apr 2012 05:13:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend core dump note section to contain file names of mapped files
Message-ID: <20120401031329.GP17822@one.firstfloor.org>
References: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I propose to save this information in core dump, as a new note
> in note segment.

Seems like a good idea but rather than write complicated code i would just reuse
the /proc/*/maps code and dump it in that format?

-Andi

