Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1JSWHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:07:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39677 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab1JSWHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:07:22 -0400
Date: Wed, 19 Oct 2011 15:07:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111019220717.GR25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org>
 <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com>
 <20111019165932.GH1140@redhat.com>
 <20111019220553.GQ25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019220553.GQ25124@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 03:05:53PM -0700, Tejun Heo wrote:
> Hmmm.... I don't know.  If we're gonna bind rule existence to that of

Heh, I meant to say, "if those two are unbound,"

> device, wouldn't it be better to simply not check whether the device
> exists?  The current behavior seems pretty confusing to me.

-- 
tejun
