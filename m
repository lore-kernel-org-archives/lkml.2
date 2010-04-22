Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0DVChd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 22:37:33 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63356 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0DVChc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 22:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=K/uSdf4K6/QPfq2rLQvTZE9mACyevbI8RBXuRoSESPtn2xWem6xojCY5lO743kV0Zt
         YFFv3UaobtYvG3tVaZx+YL7zgJco6kJE2v/xUCGENlU439FyvnJCwTmTVGWeY/H21rcb
         PBKuGMdGPjRNVjTuuH6wkbffCm4Pn9O3iSPlE=
MIME-Version: 1.0
From: Kevin Burton <burton@spinn3r.com>
Date: Wed, 21 Apr 2010 19:37:09 -0700
X-Google-Sender-Auth: 4432e0e0397b07f8
Message-ID: <h2s30c6373b1004211937z30ddf457g3eea0c621229187@mail.gmail.com>
Subject: Filesystem page cache hit rate for tuning performance of VFS page 
	cache?
To: linux kernel <linux-kernel@vger.kernel.org>,
       Jonathan Moore <moore@spinn3r.com>, Leif Ryge <leif@spinn3r.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to find out a way to tune the Linux VFS page cache.

A number of caching systems like memcached, MySQL/InnoDB page cache
export stats which can help you determine how efficient you are with
memory.

The key values I need are number of hits from the page cache and total
requests to the page cache.

These should just continually increment and rollover until we run out
of unsigned long space (2^64).

Is it possible to do this with Linux?  I'm pretty sure it's not.....
I would LOVE to be proven wrong.

I'll buy anyone a beer who solves this problem for me :)

-- 
Join the Spinn3r mailing lists:

http://groups.google.com/group/spinn3r-announce

http://groups.google.com/group/spinn3r

Founder/CEO Spinn3r.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com
