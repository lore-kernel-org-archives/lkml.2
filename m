Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1LAQ2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:28:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52967 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1LAQ2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:28:42 -0500
Message-ID: <1322756898.4699.30.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Date: Thu, 01 Dec 2011 17:28:18 +0100
In-Reply-To: <20111201154036.GA2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20111201154036.GA2443@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 10:40 -0500, Jason Baron wrote:
> I should probably rename
> static_branch() -> 'static_branch_default_false()' to make that clear.

The rename doesn't really make sense until you can also provide
static_branch_true() also:

> Maybe we need an unbiased static_branch() too, but I'm not sure excatly
> how to implement it... 

I'd think the same way we got in this situation in the first place, go
kick some GCC people ;-)
