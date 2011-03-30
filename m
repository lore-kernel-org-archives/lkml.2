Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab1C3Xaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:30:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36262 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1C3Xay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:30:54 -0400
Date: Thu, 31 Mar 2011 01:30:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110330233050.GG21838@one.firstfloor.org>
References: <20110307172609.8A01.A69D9226@jp.fujitsu.com> <20110307163513.GC13384@alboin.amr.corp.intel.com> <20110308114159.7EAD.A69D9226@jp.fujitsu.com> <20110330144507.2c0ecf73.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330144507.2c0ecf73.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do we still want it?  Are we sure we don't want the per-zone numbers?

At least I still want it and Dave Hansen did too.

I don't need per zone personally and I remember a strong request from 
anyone.  Or was there one?

-Andi
