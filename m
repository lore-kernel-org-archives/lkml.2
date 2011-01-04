Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1ADSFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:05:31 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42191 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1ADSFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:05:30 -0500
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D235E9D.1040603@redhat.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>
	 <4D234E60.3010804@redhat.com>
	 <AANLkTim8zmhKjPs-fVdR=65VPd6hybD8HA8pKEyKzm13@mail.gmail.com>
	 <1294160890.2016.171.camel@laptop>  <4D235E9D.1040603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 19:05:54 +0100
Message-ID: <1294164354.2016.187.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 12:53 -0500, Rik van Riel wrote:
> One host can have a few RT guests, say a host with 8 CPUs
> can have up to 6 or 7 RT VCPUs.  Those guests get top
> priority. 

RT guests don't make sense, there's nowhere near enough infrastructure
for that to work well.

I'd argue that KVM running with RT priority is a bug.
