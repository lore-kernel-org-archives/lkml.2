Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0FUV5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:57:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:22101 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0FUV5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,455,1272870000"; 
   d="scan'208";a="578480905"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 14:57:51 -0700
Subject: RE: [PATCH sched/core] sched,cpuset: drop __cpuexit from cpu
 hotplug callbacks
Thread-Topic: [PATCH sched/core] sched,cpuset: drop __cpuexit from cpu
 hotplug callbacks
Thread-Index: AcsRjDm6AnKX/fzESQq7haiow0yYgQAAFe8Q
Message-ID: <987664A83D2D224EAE907B061CE93D5301444DB68B@orsmsx505.amr.corp.intel.com>
References: <4C1FDF5B.1040301@kernel.org>
In-Reply-To: <4C1FDF5B.1040301@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems to work fine here but it would be nice if you can confirm
> this.  Thanks.

Yes, that works for me.  Thanks.

Acked-by: Tony Luck <tony.luck@intel.com>
