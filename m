Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1HZMw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:52:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42293 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1HZMwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:52:25 -0400
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1251
From: =?koi8-r?B?5M3J1NLJyiDpzNjJzg==?= <idv1985@gmail.com>
In-Reply-To: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
Date: Fri, 26 Aug 2011 16:52:20 +0400
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F6E761C1-015D-4E50-AC8E-31DA654157F4@gmail.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same problem here bro)

Heavy NFS based web hosting too.

I get mostly this on 38 kernel

[416779.040059] CacheFiles: Error: Overlong wait for old active object
to go away
[416779.040104] object: OBJ43981
[416779.040127] objstate=OBJECT_LOOKING_UP fl=0 wbusy=2 ev=0[7b]
[416779.040154] ops=0 inp=0 exc=0
[416779.040174] parent=ffff8800cca3c3c0
[416779.040197] cookie=ffff880100029870 [pr=ffff8801131520f0
nd=ffff88000662b180 fl=7]
[416779.040241] key=[36]
'010007010100a00800000000e6c715cb23cd4aa38338eea581f3d1045c2e680a1b56d03d'
[416779.040325] xobject: OBJ431fe
[416779.040348] xobjstate=OBJECT_RECYCLING fl=0 wbusy=2 ev=20[3]
[416779.040373] xops=0 inp=0 exc=0
[416779.040394] xparent=ffff8800cca3c3c0
[416779.040416] xcookie=NULL

And 3.0.1 kernel crashes too.

No idea how to debug…

fscache is NOT stable and looks like will never be.
NFS without cache is too slow.

CIFS is even worse.
GFS2/OCFS2 too complex and unstable.
PVFS? Coda? GlusterFS? Lustre?
They do not suite well for shared web hosting(

Looks like clustering is bad idea and we'll have to return to separate servers and caching servers.


