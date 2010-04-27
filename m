Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0D0S55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683Ab0D0S54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:57:56 -0400
Date: Tue, 27 Apr 2010 15:57:53 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] don't compute pvclock adjustments if we trust the tsc
Message-ID: <20100427185753.GR16166@mothafucka.localdomain>
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
 <1272303988-21929-2-git-send-email-glommer@redhat.com>
 <1272303988-21929-3-git-send-email-glommer@redhat.com>
 <1272303988-21929-4-git-send-email-glommer@redhat.com>
 <1272303988-21929-5-git-send-email-glommer@redhat.com>
 <1272303988-21929-6-git-send-email-glommer@redhat.com>
 <1272303988-21929-7-git-send-email-glommer@redhat.com>
 <20100427134013.GE18410@amt.cnet>
 <4BD7270B.3030201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD7270B.3030201@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 09:03:55PM +0300, Avi Kivity wrote:
> On 04/27/2010 04:40 PM, Marcelo Tosatti wrote:
> >On Mon, Apr 26, 2010 at 01:46:28PM -0400, Glauber Costa wrote:
> >>If the HV told us we can fully trust the TSC, skip any
> >>correction
> >>
> >Please drop this. Its not certain what is the best method to reduce
> >contention on the global variable. Whatever it is, can be done later.
> >
> 
> The problem is lead time.  If we (or the cpu vendors) fix this in
> the hypervisor/processors in a year, then we want existing guests to
> take advantage of it immediately.
100 % Agreed.
