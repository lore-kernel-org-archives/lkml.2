Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AUNUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:20:20 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44130 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1AUNUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:20:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=v7nlt2Xt8LWYOTzi63GB1qwAVWAmb07y814/f2Fs+9IRNZYkQYEGVjISSNjY21Jp0G
         eHiPpEeH5WaVmgzwWvkmmYyP/4XBPL8ieL6gN7yWe9urkVTUhQcwRfhvZCMCLTjKsyrQ
         GihHqMz1qTavuU6jyXk1gQquBmIE2c1HKJ19M=
Date: Fri, 21 Jan 2011 11:20:11 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Denis Kirjanov <dkirjanov@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110121132011.GA15066@ghostprotocols.net>
References: <20110120093246.GA8031@hera.kernel.org>
 <20110120114719.GD23661@elte.hu>
 <4D385866.3060405@kernel.org>
 <20110120172218.GB13482@ghostprotocols.net>
 <20110121085721.GD2994@hpt.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121085721.GD2994@hpt.nay.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 21, 2011 at 04:57:21PM +0800, Han Pingtian escreveu:
> On Thu, Jan 20, 2011 at 03:22:18PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jan 20, 2011 at 06:44:38PM +0300, Denis Kirjanov escreveu:
> > > On 01/20/2011 02:47 PM, Ingo Molnar wrote:
> > > > Wouldnt %Lu solve this in a cleaner way?

> > > I think that cleaner way is to use PRIu64.

> > Fuglier, definetely, but indeed, more portable, as I noticed when trying
> > to build the tools on a RHEL4/Fedora3 machine, as there are people using
> > such old beasts with modern kernels.

> > I'll take the patch for perf/urgent, as it prevents building in .38,
> > please consider going thru tools/perf and patching the other %Ld and
> > %Lu instances :-)

> There are also some %Lx in code, shall we change them with PRIx64?

Right, one patch doing the conversion for the whole tools/perf tree
would be better.

Han, if you can after the patch make sure it builds in an RHEL4 machine,
that would be great,

Thanks,

- Arnaldo
