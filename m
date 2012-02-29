Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031333Ab2B2TNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:13:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54337 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031176Ab2B2TNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:13:33 -0500
Message-ID: <1330542811.21491.7.camel@joe2Laptop>
Subject: RE: coding style issues -- [davem@davemloft.net: Re: pull request:
 wireless-next 2012-02-06]
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>, Kalle Valo <kvalo@qca.qualcomm.com>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, Ilan Elias <ilane@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 29 Feb 2012 11:13:31 -0800
In-Reply-To: <477F20668A386D41ADCC57781B1F70430836762D55@SC-VEXCH1.marvell.com>
References: <20120229173421.GA13733@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430836762D55@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 10:57 -0800, Bing Zhao wrote:
> Joe Perches submitted a patch "[PATCH v2] checkpatch: Add some --strict coding style checks"
> I have applied Joe's patch to my local git tree.
> 
> All new patches will follow Dave's rules and be checked with --strict option.
> Furthermore, we will have a series of cleanup patches to address the coding style issues in existing code.

Hi Bing.

There's an issue with the checkpatch patch.
It doesn't always work correctly when there
are consecutive parenthesis.

Kalle Valo showed an example that fails:

	if (!IS_ALIGNED((unsigned long) skb->data - HTC_HDR_LENGTH, 4) &&
	    skb_cloned(skb)) {

I have a tentative fix here, but I'm waiting on
Andy Whitcroft to give some guidance on how best
to fix it given a minimum perl version of 5.10.

The proposed patch doesn't work with perl versions
less than 5.10 and there is at least one person
that still uses 5.8.


