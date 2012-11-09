Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2KIOVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:21:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37871 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2KIOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:21:26 -0500
MIME-Version: 1.0
In-Reply-To: <1352466758-4596-1-git-send-email-holler@ahsoftware.de>
References: <1352466758-4596-1-git-send-email-holler@ahsoftware.de>
Date: Fri, 9 Nov 2012 15:21:24 +0100
Message-ID: <CAFLxGvzKJBA7VtzvafBry874GCiwVVWxtcktdQ=7BcVT3K2E_A@mail.gmail.com>
Subject: Re: [PATCH] x86: memtest: make it a bit faster
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 2:12 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> While implementing the same functionality for arm, I've noticed that
> memtest does an unnecessary round to zero the memory. Just reversing the
> order so that the last round writes 0s spares that round.
>
> While there, I've also changed the message if bad memory is found from
> informational to emergency.
>
> And last I've removed some warnings from checkpatch.

Please send these as additional patch.

-- 
Thanks,
//richard
