Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1JORTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:19:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:47387 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab1JORTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:19:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="63249796"
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
In-Reply-To: <CAJe_Zhe9oK9OeHxmufgkTOTGuE1qFjaaiHVNtzsqr5MUq+fqWw@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	 <CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
	 <CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
	 <1318599079.1546.395.camel@vkoul-udesk3>
	 <CAGsJ_4zSKwSm-En0TCacMTPhRG_YCaOC=aWcxF7rXWq26JcKuQ@mail.gmail.com>
	 <1318604775.1546.418.camel@vkoul-udesk3>
	 <CAJe_ZheL9EFNvPAU+shAjQG+mhOYQwXkdi1WpZ=kjn+0jWnuaw@mail.gmail.com>
	 <1318611845.23438.3.camel@vkoul-udesk3>
	 <CAJe_Zhe9oK9OeHxmufgkTOTGuE1qFjaaiHVNtzsqr5MUq+fqWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 22:41:12 +0530
Message-ID: <1318698672.23438.22.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 23:29 +0530, Jassi Brar wrote:
> 
> > Nevertheless, cyclic should be supported for all dmaengine APIs (but not
> > adding new APIs for cyclic) and in consistent manner by having a generic
> > cyclic flag and caps.
> >
> You are already merging Cyclic into Slave_sg. And Slave_sg could be
> merged into this api. So overall we would get rid one parameter passed
> outside of the parameter structure - dmaxfer_template. (Yes I want to
> reduce dependence on 'flags' argument as much as possible). 
The flags parameter already exists and we are not using it properly in
slave cases.

-- 
~Vinod

