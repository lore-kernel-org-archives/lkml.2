Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0IQDBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 23:01:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43865 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0IQDBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 23:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hNTlRpcHL/A4XuJr0opvLlpSNTdeVnAZATecGgZ4jDjFa/fakQ4f7GR1FiaqOJbjQz
         H0ke4943VOfFAuPMwXRa6XgQm7L1D9TeZH1D+QZkyxjLbv3oDd6azqU9cC4CkfgD4AQC
         +/nXAsPf4N/2ulGtGt7SNt8osR7ikGhYQHkQY=
Date: Fri, 17 Sep 2010 05:01:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Corentin Chary <corentincj@iksaif.net>
Subject: Re: EeePC 900 reboots/hangs when using using perf -a -f -g
Message-ID: <20100917030125.GA5389@nowhere>
References: <20100912102854.GA7359@sucs.org> <1284289027.2251.95.camel@laptop> <20100912112105.GA28420@sucs.org> <20100912124653.GA5342@nowhere> <20100912162141.GB30698@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912162141.GB30698@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 05:21:41PM +0100, Sitsofe Wheeler wrote:
> On Sun, Sep 12, 2010 at 02:46:56PM +0200, Frederic Weisbecker wrote:
> > 
> > Have you tried different kind of events? By default it records -e instructions
> > Can you try with -e faults for example?
> 
> This (-e faults) worked.


Ok, can you please send me your config?

I hope I can reproduce that.

Thanks.

