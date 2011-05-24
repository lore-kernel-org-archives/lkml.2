Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1EXPLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:11:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:36144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1EXPLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:11:05 -0400
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
In-Reply-To: <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
	 <1306233036.2497.15.camel@laptop>
	 <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 May 2011 17:10:30 +0200
Message-ID: <1306249830.18455.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 11:04 -0400, Vince Weaver wrote:
> 2.6.37, 2.6.38, or 2.6.39 then it would be silly to do it just for
> 2.6.40.

Oh, I assumed it was recent and .39/.40 would suffice.
