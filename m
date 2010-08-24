Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0HXNWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:22:05 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:58197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0HXNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:22:01 -0400
Subject: Re: workqueue destruction BUG_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C73C5EE.2060501@kernel.org>
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
	 <4C739DC6.1040309@kernel.org>
	 <1282646268.3695.9.camel@jlt3.sipsolutions.net>
	 <4C73BC96.6000003@kernel.org>
	 <1282655414.3695.25.camel@jlt3.sipsolutions.net>
	 <4C73C425.20503@kernel.org>
	 <1282655865.3695.27.camel@jlt3.sipsolutions.net>
	 <4C73C5EE.2060501@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 15:23:38 +0200
Message-ID: <1282656218.3695.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 15:15 +0200, Tejun Heo wrote:

> I see, thanks for verifying.  I probably got confused about the line
> number.  Hmm... weird.  I'll prep further debug patch but can you
> please tell me what you did to trigger the bug?

Not really sure. I think I need to trigger a firmware restart in iwlwifi
and then try to unload the module.

johannes

