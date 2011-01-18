Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1ARX0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:26:15 -0500
Received: from ozlabs.org ([203.10.76.45]:40616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1ARX0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:26:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: allow re-reading config space at runtime
Date: Wed, 19 Jan 2011 09:56:09 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110114160137.GA18721@lst.de> <201101181138.50421.rusty@rustcorp.com.au> <20110118122751.GA27997@lst.de>
In-Reply-To: <20110118122751.GA27997@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101190956.10137.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011 10:57:51 pm Christoph Hellwig wrote:
> On Tue, Jan 18, 2011 at 11:38:50AM +1030, Rusty Russell wrote:
> > I think we need to do better than this.  What would it take?
> 
> I don't think we have much choice.  We're getting called from irq
> context, so we'll need to allocate memory to offload things.  That's
> unless we keep a thread around that we just need to wake up, which
> would be a huge waste of ressources.

Yes, but can we keep a workqueue struct around?

Rusty.
