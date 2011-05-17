Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1EQRIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:08:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab1EQRIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:08:40 -0400
Date: Tue, 17 May 2011 10:08:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] w1: Add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge
 IC support.
Message-Id: <20110517100846.bcb3adbc.akpm@linux-foundation.org>
In-Reply-To: <4DD29578.4020807@indesign-llc.com>
References: <4DCACAA1.902@indesign-llc.com>
	<4DD29578.4020807@indesign-llc.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011 11:34:16 -0400 Clifton Barnes <cabarnes@indesign-llc.com> wrote:

> I'm in the process of making the other changes that were suggested.
> How should I submit the changes?  A new patch v3 or a patch to v2?
> If a patch to v2, how should that be indicated?

Either a v3 patch against current mainline or a smaller patch against
mainline+v2.  The former is better for new reviewers and the latter is
better for people who have already reviewed the code.  Either is OK for
me.  When someone sends me a v3 I'll always turn it into the v2->v3
delta anyway, so I can see what changed.



