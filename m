Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1JSWGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:06:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37418 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1JSWF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:05:59 -0400
Date: Wed, 19 Oct 2011 15:05:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111019220553.GQ25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org>
 <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com>
 <20111019165932.GH1140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019165932.GH1140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 12:59:32PM -0400, Vivek Goyal wrote:
> Are you trying to tie the rules with actual presence of device. Current
> model is that we just check for a valid device while somebody is
> specifying the rule. After that device can go away and rule can still
> be there.  We are just trying to make sure that when you are putting
> the rule, atleast at that time device is present.

Hmmm.... I don't know.  If we're gonna bind rule existence to that of
device, wouldn't it be better to simply not check whether the device
exists?  The current behavior seems pretty confusing to me.

Thanks.

-- 
tejun
