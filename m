Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab0JZU1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:27:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42849 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab0JZU1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:27:38 -0400
Date: Tue, 26 Oct 2010 22:27:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
Message-ID: <20101026202734.GB2603@basil.fritz.box>
References: <20101026123828.GA30434@basil.fritz.box>
 <4CC70333.80400@zytor.com>
 <20101026163748.GB29961@basil.fritz.box>
 <4CC705ED.1020105@zytor.com>
 <20101026170142.GD29961@basil.fritz.box>
 <4CC71B94.2010802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC71B94.2010802@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is an issue too, as 3.x does a lot fewer optimizations than 4.x.

Well to be fair the default -Os build disables most of the fancy stuff
(and the resulting code is often terrible) 

I guess it doesn't matter too much, at least not with the 
CONFIG_CC_OPTIMIZE_SIZE default.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
