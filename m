Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2DSWCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:02:39 -0400
Received: from void.printf.net ([89.145.121.20]:48792 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab2DSWCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:02:37 -0400
From: Chris Ball <cjb@laptop.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: linux-next: triage for April 18, 2012
References: <20120419020136.GB3443@windriver.com>
Date: Thu, 19 Apr 2012 18:02:46 -0400
In-Reply-To: <20120419020136.GB3443@windriver.com> (Paul Gortmaker's message
	of "Wed, 18 Apr 2012 22:01:36 -0400")
Message-ID: <878vhrjs6x.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 18 2012, Paul Gortmaker wrote:
> ARM:mackerel_defconfig,ag5evm_defconfig
> 	when:	Apr 19 (possibly earlier?)
> 	why:	pfc-sh7372.c: undefined reference to `mmc_detect_change'
> 	why:	pfc-sh73a0.c: undefined reference to `mmc_detect_change'
> 	status:	
> 	fix:	
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131930/
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131908/

Adding Guennadi and Magnus to CC for this error (which is coming from
tmio_mmc_cd_wakeup).

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
