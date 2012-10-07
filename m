Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab2JGVHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:07:38 -0400
Received: from 1wt.eu ([62.212.114.60]:36009 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab2JGVHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:07:36 -0400
Date: Sun, 7 Oct 2012 23:07:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>
Subject: Re: 3.5 regression on i915
Message-ID: <20121007210727.GI22618@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <b94cdc$6rvjl8@fmsmga001.fm.intel.com> <20121006082016.GA22618@1wt.eu> <20121007210031.GE7352@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007210031.GE7352@phenom.ffwll.local>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 11:00:31PM +0200, Daniel Vetter wrote:
> Applied to -fixes, with cc: stable and a note mentioning the regressing
> commit sha1 added.

Thanks to you and Chris for the quick diag & fix !

Willy

