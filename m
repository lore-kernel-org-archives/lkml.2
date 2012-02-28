Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2B1UKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:10:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48035 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2B1UKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:10:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.226.41 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Wed, 29 Feb 2012 05:10:09 +0900
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix generic definition of
 __this_cpu_add_and_return()
Message-ID: <20120228201009.GB3252@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120219142911.12300.7497.stgit@zurg>
 <CAPVoSvSimdFfkxSqtW3Gzf+J-sPPzVuyyUEf7Zxo4HLmBx9kxw@mail.gmail.com>
 <alpine.DEB.2.00.1202240942510.2621@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1202240942510.2621@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 09:43:15AM -0600, Christoph Lameter wrote:
> On Fri, 24 Feb 2012, Torsten Kaiser wrote:
> 
> > >  #define __this_cpu_sub_return(pcp, val)        this_cpu_add_return(pcp, -(val))
> >
> > I think, the same fix should be applied to the lines following this patch:
> > #define __this_cpu_sub_return(pcp, val) this_cpu_add_return(pcp, -(val))
> > #define __this_cpu_inc_return(pcp)      this_cpu_add_return(pcp, 1)
> > #define __this_cpu_dec_return(pcp)      this_cpu_add_return(pcp, -1)
> >
> > Shouldn't these other operations also only give the __ relaxed guarantees?
> Yes indeed that should also be fixed.

Can someone please send a patch for this? :)

Thanks.

-- 
tejun
