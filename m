Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2ARQzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:55:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52502 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2ARQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:55:23 -0500
Date: Wed, 18 Jan 2012 08:55:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120118165518.GC30664@google.com>
References: <20120118010323.GA32160@htj.dyndns.org>
 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
 <20120118011112.GB32160@htj.dyndns.org>
 <1326850253.22361.619.camel@sli10-conroe>
 <1326866602.22361.624.camel@sli10-conroe>
 <20120118135126.GB30204@redhat.com>
 <20120118142005.GC30204@redhat.com>
 <20120118160957.GB30664@google.com>
 <4F16F245.9000708@kernel.dk>
 <4F16F3CA.90904@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F16F3CA.90904@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Wed, Jan 18, 2012 at 05:31:06PM +0100, Jens Axboe wrote:
> Something like the below, completely untested.

Yeah, I was thinking about mostly identical approach.  We should do
about the same thing for elv_bio_merged() too.

> But thinking about this a bit while doing it, why is the IO scheduler
> going away while we have plugged requests that are elvpriv?

AFAICS, we don't check whether the request has priv or not.

Thanks.

-- 
tejun
