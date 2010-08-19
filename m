Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0HSLpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:45:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62834 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0HSLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FP13R/nMZXPU/O3aTp6chy6wnt7/Fh1uEjSErjatQXHhLtrB/e/1WLRa0/Cc9BDbgG
         r8AEnGNDPVBiJrHsACi8aY59cyJc9v/kMD4z1+0OB2MKTzU/4/aSPAYKtAiikjxxmTVE
         KNfm2WAXL62AOWJq7GelTj5bq2qpXIJUUukQ0=
Date: Thu, 19 Aug 2010 08:26:16 +0530
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/mkversion: Simplify script
Message-ID: <20100819023705.GF3688@kytes>
References: <1282165945-27195-1-git-send-email-artagnon@gmail.com>
 <20100819002006.GA13637@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819002006.GA13637@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sam Ravnborg writes:
> On Thu, Aug 19, 2010 at 02:42:25AM +0530, Ramkumar Ramachandra wrote:
> > Simplify the script and add a line to help editors recognize this as a
> > shell script.
> 
> This does not IMO simplify the script.
> The original version is simple to follow for the usual C coder.
> The new version is harder to follow.
> 
> Adding the bangshee (#!/bin/sh) is fine.

Okay, we can drop the patch.
I'll pick up some other janiorial tasks to get into the hang of
writing patches.

-- Ram
