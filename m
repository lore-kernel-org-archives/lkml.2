Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1HQNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:25:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48940 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab1HQNZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:25:28 -0400
Subject: Re: [PATCH 12/41] microblaze: Don't reimplement force_sigsegv()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110817131444.GA13676@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-13-git-send-email-matt@console-pimps.org>
	 <20110816172010.GC29190@redhat.com> <20110816172049.GD29190@redhat.com>
	 <4E4BBB8D.5020307@monstr.eu>  <20110817131444.GA13676@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 14:25:25 +0100
Message-ID: <1313587525.2311.22.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 15:14 +0200, Oleg Nesterov wrote:
> 
> Assuming the changelog is fixed,
> 
> 	Acked-by: Oleg Nesterov <oleg@redhat.com>

Thanks!

> > If you want to propose 12-15 through my Microblaze tree, please let me know.
> 
> Probably this is the best option. Matt, what do you think?

Yeah, that seems like the best solution. All of the patches are
independent so it's easy for the respective maintainers to apply them
when they're ready.

I'll be sending out updated versions today.

-- 
Matt Fleming, Intel Open Source Technology Center

