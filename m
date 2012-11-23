Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2KWMBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:01:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2KWMBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:01:03 -0500
Date: Fri, 23 Nov 2012 13:00:55 +0100
From: Robert Richter <rric@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20121123120055.GE24690@rric.localhost>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
 <1274347413.5605.13636.camel@twins>
 <20100520152221.GR21799@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520152221.GR21799@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.10 17:22:21, Robert Richter wrote:
> > > Dunno, reconstruct sensible counters? Surely the software that uses IBS
> > > does something useful with that data? What does libpfm do with the IBS
> > > data?
> 
> Here are some use cases described:
> 
>  http://developer.amd.com/assets/AMD_IBS_paper_EN.pdf
>  http://developer.amd.com/cpu/CodeAnalyst/assets/ISPASS2010_IBS_CA_abstract.pdf

A copy of this document can be found here:

 http://www.kernel.org/pub/linux/kernel/people/rric/ISPASS2010_IBS_CA_abstract.pdf

-Robert
