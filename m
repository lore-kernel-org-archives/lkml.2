Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0CYOOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:14:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab0CYOO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:14:29 -0400
Date: Thu, 25 Mar 2010 11:13:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, zhiteng.huang@intel.com,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 3/3] perf events: Change perf parameter --pid to
	process-wide collection instead of thread-wide
Message-ID: <20100325141351.GG3625@ghostprotocols.net>
References: <1268904666.2813.172.camel@localhost> <4BAB1881.8020500@cn.fujitsu.com> <1269506864.2078.75.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269506864.2078.75.camel@ymzhang.sh.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 25, 2010 at 04:47:44PM +0800, Zhang, Yanmin escreveu:
> On Thu, 2010-03-25 at 16:02 +0800, Li Zefan wrote:
> Thanks for reporting it. Arnaldo, could you pick up below patch?
> Zefan, Could you try it?

Sure thing, will stash them in today's push to Ingo, thanks!

- Arnaldo
