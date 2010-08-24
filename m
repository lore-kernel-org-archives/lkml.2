Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0HXNCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:02:47 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:44450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0HXNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:02:45 -0400
Subject: Re: workqueue destruction BUG_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C73BC96.6000003@kernel.org>
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
	 <4C739DC6.1040309@kernel.org>
	 <1282646268.3695.9.camel@jlt3.sipsolutions.net>
	 <4C73BC96.6000003@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 15:04:21 +0200
Message-ID: <1282655061.3695.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 14:35 +0200, Tejun Heo wrote:

> Can you please apply the following patch and report the result?
> 
> Thanks.
> 
> From 492a242b75b0abae3b1c17b4a654ab9ef67e612d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 24 Aug 2010 14:22:47 +0200
> Subject: [PATCH] workqueue: improve destroy_workqueue() debuggability

Thanks, will do. I couldn't reproduce right away, but I had it quite
frequently yesterday so I'll go back to what I was testing yesterday.

johannes

