Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922Ab2CNQa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:30:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34378 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759450Ab2CNQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:30:25 -0400
Date: Wed, 14 Mar 2012 12:26:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: [PATCH 1/2] [CPUFREQ]: provide disable_cpufreq() function to
 disable the API.
Message-ID: <20120314162615.GD16960@phenom.dumpdata.com>
References: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
 <1331680720-18268-2-git-send-email-konrad.wilk@oracle.com>
 <20120314142543.GB2371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314142543.GB2371@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F60C79C.0077,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:25:43AM -0400, Dave Jones wrote:
> On Tue, Mar 13, 2012 at 07:18:39PM -0400, Konrad Rzeszutek Wilk wrote:
>  > useful for disabling cpufreq altogether. The cpu frequency
>  > scaling drivers and cpu frequency governors will fail to register.
> 
> looks good to me. Are you ok with me taking 1/2 through cpufreq.git, and
> then you pushing the xen bit yourself ?

No trouble! Thanks!
> (or I could take them both if it makes things easier)
> 
> 	Dave
