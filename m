Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab0FWGWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:22:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54071 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab0FWGWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:22:46 -0400
Date: Tue, 22 Jun 2010 23:22:42 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux File System ML <linux-fsdevel@vger.kernel.org>,
       Linux Security Module ML 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: Yama LSM
Message-ID: <20100623062242.GG5876@outflux.net>
References: <20100621213424.GG24749@outflux.net>
 <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp>
 <20100622011452.GN24749@outflux.net>
 <4C20ABC0.5050908@nokia.com>
 <20100622160613.GC5876@outflux.net>
 <4C21A39C.6040406@ontolinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C21A39C.6040406@ontolinux.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 08:03:08AM +0200, Christian Stroetmann wrote:
> "You've already had those suggestions some days ago. Use a security
> module, either by using something like SELinux (where you can do
> this just fine as far as I can see including exceptions by label for
> problem apps)", [Alan Cox, 2010-06-08], or integrate it into an
> already existing solution eg. grsecurity (www.grsecurity.net).

You appear to be quoting[1], but you left off a bit.  To edit it a bit:

  "Use a security module, either by using something like SELinux (...),
  or write your own little security module that does it."

I have done the latter.

I don't need to integrate this into grsecurity because grsecurity already
has these protections.  It is Openwall and grsecurity that I'm using as the
starting point for this attempt at upstreaming the protections.

-Kees

[1] http://lkml.org/lkml/2010/6/8/56

-- 
Kees Cook
Ubuntu Security Team
