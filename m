Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab0E0PJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:09:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab0E0PJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:09:27 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul@smtp1.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271053420.3239-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1005271053420.3239-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 17:09:16 +0200
Message-ID: <1274972956.27810.5161.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 11:06 -0400, Alan Stern wrote:
> 
>         Opportunistic suspends are okay.
> 
>         The proposed userspace API is too Android-specific.

I would argue opportunistic suspends are not ok, and therefore the
proposed API is utterly irrelevant.
