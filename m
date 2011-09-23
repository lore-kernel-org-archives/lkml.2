Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1IWSvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:51:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57200 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab1IWSv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109221426310.19558@cobra.newdream.net>
References: <CAB2gnbVw2_FSWVVmUA1OobE1Ti9Q1w3AP_67=Vo4zwZtQ=gHYg@mail.gmail.com>
	<Pine.LNX.4.64.1109221426310.19558@cobra.newdream.net>
Date: Fri, 23 Sep 2011 11:51:27 -0700
Message-ID: <CAB2gnbVaS=x9hurY0P8x4Ltqh11foOpsMBy2MNt662T2X9+BLQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: use kernel DNS resolver
From: Noah Watkins <noahwatkins@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 14:29, Sage Weil <sage@newdream.net> wrote:
> Currently the dns resolution is handled by mount.ceph and 'rbd map/unmap'.
> I don't think that will go away (at the very least need to support old
> kernels).

This is good to know. I never encountered the DNS lookup because I've
always used a non-standard installation path, avoiding mount.ceph.

> Allowing this in the raw kernel interface would be nice, but I don't think
> we want make DNS_RESOLVER a strict dependency, since it's new, kind of
> kludgey, and a ripe target for compiling out of small or secure kernels.
> Can you make it build either with or without it?

I sent out a new version of the patch that defines a libceph specific
configuration
option to use the in-kernel dns resolver.

Thanks for the feedback!
-Noah
