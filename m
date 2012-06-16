Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2FPMrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 08:47:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2FPMrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 08:47:02 -0400
Message-ID: <1339850806.15222.9.camel@twins>
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore
 support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Sat, 16 Jun 2012 14:46:46 +0200
In-Reply-To: <CABPqkBR6FXo-uKFGVgVCgjycSqZ6Ye5r5f6HB35zD9auQRcr5w@mail.gmail.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
	 <1339781398.2559.94.camel@twins>
	 <CABPqkBR6FXo-uKFGVgVCgjycSqZ6Ye5r5f6HB35zD9auQRcr5w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 20:47 +0200, Stephane Eranian wrote:
> That's becase some uncore have 1 fixed counter to count uncore cycles.
> That means no specific encoding, so we need to make one up just like
> for core PMU and the ref-cycle event. 

Would've been nice to have that mentioned somewhere...
