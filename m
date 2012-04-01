Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2DAQxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:53:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59551 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2DAQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:53:43 -0400
Date: Sun, 1 Apr 2012 18:53:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend core dump note section to contain file names of mapped files
Message-ID: <20120401165339.GR17822@one.firstfloor.org>
References: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com> <20120401031329.GP17822@one.firstfloor.org> <201204011533.51628.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204011533.51628.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It uses seq_printf(). It will need refactoring if we would
> want to use it for purposes other than /proc pseudo-file
> generation.

seq_file just writes to a buffer. I'm sure there's a way to get at that
buffer. In theory you could also just copy using read/write and a small temp
buffer. The only problem would be to stop it taking the vm sem.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
