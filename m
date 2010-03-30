Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0C3QnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:43:23 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:40490 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0C3QnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:43:22 -0400
Date: Tue, 30 Mar 2010 11:43:00 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch v2] slab: add memory hotplug support
In-Reply-To: <84144f021003300201x563c72vb41cc9de359cc7d0@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003301141190.24717@router.home>
References: <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>  <20100226155755.GE16335@basil.fritz.box>  <alpine.DEB.2.00.1002261123520.7719@router.home>  <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> 
 <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>  <20100305062002.GV8653@laptop>  <alpine.DEB.2.00.1003081502400.30456@chino.kir.corp.google.com>  <20100309134633.GM8653@laptop>  <alpine.DEB.2.00.1003271849260.7249@chino.kir.corp.google.com>
  <alpine.DEB.2.00.1003271940190.8399@chino.kir.corp.google.com> <84144f021003300201x563c72vb41cc9de359cc7d0@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Pekka Enberg wrote:

> Nick, Christoph, lets make a a deal: you ACK, I merge. How does that
> sound to you?

I looked through the patch before and slabwise this seems to beok but I am
still not very sure how this interacts with the node and cpu bootstrap.
You can have the ack with this caveat.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

