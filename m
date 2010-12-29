Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0L2Pxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 10:53:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab0L2Pxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 10:53:44 -0500
Date: Wed, 29 Dec 2010 08:53:29 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCH 10/16] ub: convert to bdops->check_events()
Message-ID: <20101229085329.772e1dc0@lembas.zaitcev.lan>
In-Reply-To: <1293557352-10592-11-git-send-email-tj@kernel.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
	<1293557352-10592-11-git-send-email-tj@kernel.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010 18:29:06 +0100
Tejun Heo <tj@kernel.org> wrote:

> Convert from ->media_changed() to ->check_events().
> 
> ub buffers media changed state and clears it on revalidation.  It will
> behave correctly with kernel event polling.

If you say so, I don't mind. I reserve the right to come back to you
if I find breakage in testing (I have a ZIP drive that has a real
media change).

-- Pete
