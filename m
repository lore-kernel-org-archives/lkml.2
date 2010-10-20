Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab0JTLVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:21:07 -0400
Received: from canuck.infradead.org ([134.117.69.58]:39801 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0JTLVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:21:06 -0400
Subject: Re: [PATCH 2/2]x86: spread tlb flush vector between nodes
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20101020073155.GB20124@basil.fritz.box>
References: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
	 <1287551797.2700.76.camel@edumazet-laptop>
	 <20101020073155.GB20124@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 13:20:52 +0200
Message-ID: <1287573652.3488.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 09:31 +0200, Andi Kleen wrote:
> Really a lot of the per CPU scaling we have today should be per core
> or per node to avoid explosion. 

Shouldn't that be per-cache instead of per-core?
