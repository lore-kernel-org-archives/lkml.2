Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2GYRwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:52:51 -0400
Received: from longford.logfs.org ([213.229.74.203]:57421 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab2GYRwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:52:50 -0400
Date: Wed, 25 Jul 2012 12:39:05 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120725163905.GA28036@logfs.org>
References: <20120424205946.GH20610@logfs.org>
 <201207240901.16151.tvrtko.ursulin@onelan.co.uk>
 <20120724143822.GA24954@logfs.org>
 <201207250917.09516.tvrtko.ursulin@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201207250917.09516.tvrtko.ursulin@onelan.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 July 2012 09:17:09 +0100, Tvrtko Ursulin wrote:
> 
> As far as I know there is nothing like netpoll in the block layer so it has to 
> be a lot less reliable than netconsole. Especially with delaying write out to 
> a workqueue. Anyway, I am not arguing, just saying in my opinion those caveats 
> are worth documenting.
...
> My point was that it's reliability will differ depending on the block device 
> in use, which is unlike netconsole. Again I am not arguing against the 
> feature, but if you don't see things like these are worth documenting I give 
> up.

I have nothing against documenting things.  Can you suggest something
better than "reliability of blockconsole will depend on the
reliability of the underlying storage layer", which sounds rather
obvious?

Jörn

--
I don't understand it. Nobody does.
-- Richard P. Feynman
