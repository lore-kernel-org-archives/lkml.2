Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab1LMTh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:37:57 -0500
Received: from [205.233.59.134] ([205.233.59.134]:52018 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1LMThy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:37:54 -0500
Message-ID: <1323805015.9082.41.camel@twins>
Subject: Re: [PATCH 1/3] kref: Inline all functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Date: Tue, 13 Dec 2011 20:36:55 +0100
In-Reply-To: <20111213191125.GA3797@kroah.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.107647845@chello.nl> <20111212221159.GA27940@kroah.com>
	 <1323768980.9082.6.camel@twins> <20111213171511.GA17096@kroah.com>
	 <1323802323.9082.20.camel@twins> <20111213191125.GA3797@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 11:11 -0800, Greg KH wrote:
> 
> QUILT_REFRESH_ARGS="--diffstat --strip-trailing-whitespace --no-timestamps --no-index --sort -p1 -p ab"
> QUILT_DIFF_ARGS="--no-timestamps --no-index --sort --color=auto -p ab" 

Ah, its the --no-index that does that. I also missed the --sort and -p
ab thing, the rest I already had.

Thanks!
