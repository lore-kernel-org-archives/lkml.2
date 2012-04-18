Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2DRPCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:02:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:34702 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2DRPCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:02:09 -0400
Date: Thu, 19 Apr 2012 01:02:05 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [PULL REQUEST] : ima-appraisal patches
In-Reply-To: <1334754302.2137.8.camel@falcor>
Message-ID: <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
References: <1334754302.2137.8.camel@falcor>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Mimi Zohar wrote:

> Hi James,
> 
> As the last IMA-appraisal posting on 3/29 addressed Al's
> performance/maintenance concerns of deferring the __fput() and there
> hasn't been any additional comments, please consider pulling the
> IMA-appraisal patches.

I thought Dmitry was still waiting on comments from Al for this.



- James
-- 
James Morris
<jmorris@namei.org>
