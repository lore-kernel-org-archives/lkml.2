Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab2FZQVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:21:43 -0400
Received: from 1wt.eu ([62.212.114.60]:3454 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704Ab2FZQVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:21:42 -0400
Date: Tue, 26 Jun 2012 18:21:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Lukas Anzinger <l.anzinger@gmail.com>, Adam Jackson <ajax@redhat.com>,
        Eric Anholt <eric@anholt.net>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [2.6.32.y] drm/i915: Attempt to fix watermark setup on 85x (v2)
Message-ID: <20120626162122.GA6413@1wt.eu>
References: <1340625038-11257-1-git-send-email-stefan.bader@canonical.com> <20120626041458.GC3010@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626041458.GC3010@burratino>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Mon, Jun 25, 2012 at 11:14:58PM -0500, Jonathan Nieder wrote:
> From: Adam Jackson <ajax@redhat.com>
> Date: Fri, 16 Apr 2010 18:20:57 -0400
> 
> commit 8f4695ed1c9e068772bcce4cd4ff03f88d57a008 upstream.
> 
> IS_MOBILE() catches 85x, so we'd always try to use the 9xx FIFO sizing;
> since there's an explicit 85x version, this seems wrong.
> 
> v2: Handle 830m correctly too.
> 
> [jn: backport to 2.6.32.y to address
>  https://bugzilla.kernel.org/show_bug.cgi?id=42839]

(...)

Thank you, I've queued it for 2.6.32.60.

Best regards,
Willy

