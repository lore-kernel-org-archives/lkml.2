Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0ERFVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab0ERFV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:21:29 -0400
Date: Tue, 18 May 2010 10:52:30 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] fix a code style in drivers/char/virtio_console.c
Message-ID: <20100518052230.GA1706@amit-laptop.redhat.com>
References: <AANLkTilW8zZxCOrdiefZ4ZtixprI58LzDZ6Cz03z4lFk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilW8zZxCOrdiefZ4ZtixprI58LzDZ6Cz03z4lFk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) May 18 2010 [13:17:22], Steven Liu wrote:
> fix a code style in drivers/char/virtio_console.c
> 
> Signed-off-by: Liu Qi <lingjiujianke@gmail.com>

NACK.

This style is deliberate and follows Rusty's style: if we end up using
'err' uninitialised in some code path, it can get flagged by source
checkers.

		Amit
