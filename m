Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0H0INe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:13:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:47550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0H0INd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:13:33 -0400
Subject: Re: divide by zero bug in find_busiest_group
From: Peter Zijlstra <peterz@infradead.org>
To: Chetan Ahuja <chetan.ahuja@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <1282895494.1975.1693.camel@laptop>
References: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
	 <AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
	 <AANLkTikg7Q_oOecNgVLPPTu3dOu3aO776f4y1bw410PV@mail.gmail.com>
	 <1282895494.1975.1693.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 10:13:30 +0200
Message-ID: <1282896810.1975.1768.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 09:51 +0200, Peter Zijlstra wrote:
> 
> Load balancing works by balancing this group hierarchy, a number of
> groups are contained in a domain. Each cpu does a load-balance pull,
> from the busiest group in that domain to his local domain. 

s/local domain/local group/

> Since there's
> ever smaller groups/domains you eventually end up with a nicely spread
> load. 
