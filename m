Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab0FOW1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:27:38 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:33216 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581Ab0FOW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:27:36 -0400
Message-Id: <201006152225.AA00434@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Wed, 16 Jun 2010 07:25:47 +0900
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100614141447.d11c5dac.akpm@linux-foundation.org>
References: <20100614141447.d11c5dac.akpm@linux-foundation.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 14 Jun 2010 14:14:47 -0700 Andrew Morton wrote:

> I still don't think we should have a kernel boot option for this - it
> just doesn't seem useful enough.  Can we please just hard-wire the
> blinking frequency?  And once we've done that, we don't have to jump
> through hoops with this "wpm" thing.  We can use Hz.

Hmm, OK.  I understand your request.

I will repost new patch in a few days.

Please wait for a while.

Regards,
TAMUKI Shoichi
