Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848Ab0KQHkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:40:00 -0500
Received: from tomasu.net ([64.85.170.234]:58754 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab0KQHj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:39:59 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: kernel lockups with 2.6.36
Date: Wed, 17 Nov 2010 00:39:54 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
References: <201011141009.15691.thomas@fjellstrom.ca>
In-Reply-To: <201011141009.15691.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011170039.54869.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 14, 2010, you wrote:
> Today I experienced something odd, several kernel threads locked up in
> several different subsystems. It caused X to lock up, and not draw
> anything, access to nfs died, and trying to unmount, remount readonly, or
> do much other than ssh and copy files with scp (which may or may not have
> been in cache, might have been) locked up.
> 
> I'm using a vanila 2.6.36.
> 
> It looks to me like fscache/cachefiles may have started the problem, but I
> can't be sure, and I'm not entirely sure why that would cause i915 to lock
> up as well. I've disabled cachefiles for now, thinking that might make it
> go away. (its locked up twice today)
> 
> here's the entire dmesg:
[snip]

Does anyone know whats going on here? Is it just a fscache bug? Or something a 
little more insidious (since it seemed to cause a drm/intel_gfx lockup as 
well?)

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
