Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0DWAeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0DWAeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:34:06 -0400
Date: Thu, 22 Apr 2010 20:33:37 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, NeilBrown <neilb@suse.de>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [166/197] md/raid5: allow for more than 2^31
 chunks.
Message-ID: <20100422203338.617debf9@redhat.com>
In-Reply-To: <20100422190922.238365037@kvm.kroah.org>
References: <20100422191857.GA13268@kroah.com>
	<20100422190922.238365037@kvm.kroah.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 12:10:17 -0700
Greg KH <gregkh@suse.de> wrote:

> 2.6.32-stable review patch.  If anyone has any objections, please let
> us know.
> 
> ------------------
> 
> From: NeilBrown <neilb@suse.de>
> 
> commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> 
> With many large drives and small chunk sizes it is possible
> to create a RAID5 with more than 2^31 chunks.  Make sure this
> works.

Causes build failure on i686:
ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!

http://lkml.org/lkml/2010/4/22/50

