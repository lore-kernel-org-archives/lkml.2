Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2JEX65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 19:58:57 -0400
Received: from 1wt.eu ([62.212.114.60]:35970 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2JEX6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 19:58:55 -0400
Date: Sat, 6 Oct 2012 01:58:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: Re: 3.5 regression on i915
Message-ID: <20121005235845.GE21163@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 09:48:57AM +1000, Dave Airlie wrote:
> Any reason you don't have KMS, you'll keep hitting these non-kms bugs
> since it has no users anymore really.
> 
> Granted they'll get fixed, but I suspect its a losing battle over time.

Well, back in old times every time I tried to enable it, I only ran into
problems so I got used to disable it, which made sense since it didn't
bring me any benefit.

I can retry with it if needed, but if we consider that it is necessary,
then we should probably not allow it to be disabled anymore, since my
working 3.4 config fails on 3.5 with "make oldconfig".

Willy

