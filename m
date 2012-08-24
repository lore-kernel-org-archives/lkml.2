Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab2HXEJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:09:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33440 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2HXEI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:08:59 -0400
Date: Fri, 24 Aug 2012 05:08:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Bernhard Rosenkraenzer <bernhard.rosenkranzer@linaro.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 1/1] perf: Port to Android
Message-ID: <20120824040845.GA3001@srcf.ucam.org>
References: <1408973.PFKjjaXiS1@localhost.localdomain>
 <CAOJsxLFgvqJUwwnrtH8b9eOfNzUEZDmQGP1FVvToitD6ayYP0g@mail.gmail.com>
 <5036A182.7030707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036A182.7030707@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 03:32:50PM -0600, David Ahern wrote:

> Why not add support for the missing functions (on_exit, getsid,
> psignal and getline) to Bionic instead of perf?

Many vendors need to target existing Android platforms and don't have 
the luxury of waiting for code to get through Google review and then 
land on devices between 6 months in the future and never. The embedded 
world is dysfunctional in a whole bunch of ways.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
