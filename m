Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0C1L6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:58:01 -0400
Received: from 8bytes.org ([88.198.83.132]:44812 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab0C1L57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:57:59 -0400
Date: Sun, 28 Mar 2010 13:57:58 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Naresh Rapolu <nrapolu@purdue.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hardware performance events are not counted by  "perf"   in a
	2.6.31.12 KVM guest
Message-ID: <20100328115758.GP14800@8bytes.org>
References: <4BAD675E.3050600@purdue.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAD675E.3050600@purdue.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:03:10PM -0400, Naresh Rapolu wrote:
> "perf"  tool does not count  hardware performance events ( cache misses  
> etc) in a  KVM guest ( Ubuntu 9.10 karmic,  2.6.31-14-generic  kernel)  
> on  Xeon 5530 quad-core.  The host  is  2.6.28  kernel , Ubuntu 8.04  
> LTS, Hardy.

The KVM guest has no access to the hardware counters of the cpu. KVM
ignores these accesses from guests. Making this work needs proper
virtualization of the PMU which is not implemented yet.

Regards,

	Joerg

