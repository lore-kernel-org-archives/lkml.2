Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1G0Vzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:55:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58635 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab1G0Vzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:55:31 -0400
Date: Wed, 27 Jul 2011 23:55:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@hansenpartnership.com,
        penberg@kernel.org, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, stable@vger.kernel.org
Subject: Re: [PATCH] [12/98] slub: fix panic with DISCONTIGMEM
Message-ID: <20110727215527.GE8006@one.firstfloor.org>
References: <20110726534.972201586@firstfloor.org> <20110727003504.30F242403FF@tassilo.jf.intel.com> <alpine.DEB.2.00.1107271444040.13279@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107271444040.13279@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NACK, this got reverted by 21a43e397e7f ("slub: Revert '[PARISC] slub: fix 
> panic with DISCONTIGMEM'").  Merging d9b41e0b54fd ("[PARISC] set memory 
> ranges in N_NORMAL_MEMORY when onlined") does not require this change.

Dropped.
-Andi
