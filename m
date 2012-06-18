Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2FRHmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:42:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44766 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2FRHmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:42:35 -0400
Message-ID: <1340005336.15222.16.camel@twins>
Subject: Re: [PATCH V6 08/13] perf: Add Sandy Bridge-EP uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Jun 2012 09:42:16 +0200
In-Reply-To: <4FDE88AF.3010902@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	  <1339741902-8449-9-git-send-email-zheng.z.yan@intel.com>
	 <1339780230.2559.86.camel@twins> <4FDE88AF.3010902@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 09:47 +0800, Yan, Zheng wrote:

> Sorry, my document is out-dated. These events were listed in the old
> document. should we remove them ?

No idea, ask someone from the hardware team for clarification.

If these events were scrapped because they failed to pass validation or
so, it doesn't really matter if we include the constraints since the
results are screwy anyway -- unless of course programming these events
'wrong' will screw over something else.


