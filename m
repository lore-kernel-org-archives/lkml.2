Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1DUVKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:10:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:32924 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1DUVKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:10:12 -0400
Date: Thu, 21 Apr 2011 23:10:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stratos Psomadakis <psomas@ece.ntua.gr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421211011.GB6196@merkur.ravnborg.org>
References: <20110421192117.GA14249@redhat.com> <4DB093E6.3040909@ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB093E6.3040909@ece.ntua.gr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This new gcc-4.6.0 behavior can also cause build failures for archs
> which use -Werror by default (sparc, ppc) [1][2].
> 
> [1] https://lkml.org/lkml/2011/4/19/383
> [2] https://lkml.org/lkml/2011/4/18/287

sparc was easy to fix.
alpha dropped -Werror for now.

	Sam
