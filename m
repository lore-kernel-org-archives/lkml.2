Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2FNNgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:36:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55691 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2FNNgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:36:53 -0400
Date: Thu, 14 Jun 2012 15:36:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
Message-ID: <20120614133647.GH11413@one.firstfloor.org>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org> <1339618842-26636-3-git-send-email-andi@firstfloor.org> <20120614091001.GA22155@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614091001.GA22155@liondog.tnic>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You still haven't told me what's the use of this printk statement to the
> user. Should she update her microcode, buy a new box or go up in flames?

It gives any kernel developer a hint that something is fishy with the
configuration. For once it will disable the bug workarounds.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
