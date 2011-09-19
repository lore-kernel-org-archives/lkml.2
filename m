Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1ISSlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:41:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47482 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab1ISSlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:41:16 -0400
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Mon, 19 Sep 2011 20:40:53 +0200
In-Reply-To: <4E7770BD.6050902@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	    <1316030695-19826-2-git-send-email-glommer@parallels.com>
	   <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>
	  <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com>
	 <1316450385.6091.9.camel@twins> <4E7770BD.6050902@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316457653.6091.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 13:41 -0300, Glauber Costa wrote:
> On 09/19/2011 01:39 PM, Peter Zijlstra wrote:
> > On Mon, 2011-09-19 at 13:30 -0300, Glauber Costa wrote:
> >> Since this value is at least intended to
> >> provide a basis for cpu capping in the near future (Well, it is not
> >> there, but I think it is), it is expected to be used much more
> >> frequently by the kernel itself.
> >
> > We just merged a bandwidth limiter quite separate from cpuacct.
> 
> Note I was talking about cpuusage. Well, in this case, I myself fail
> to see the value of the whole cpuusage thing... Someone that sees 
> further could maybe help us out here? (but this is sideways to the whole 
> discussion we're having anyway)

Would probably do to cc the cpuacct authors in this patch set ;-) I
think it came from IBM, so I added vatsa.
