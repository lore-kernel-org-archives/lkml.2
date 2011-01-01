Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1AABDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 20:03:51 -0500
Received: from science.horizon.com ([71.41.210.146]:42498 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750808Ab1AABDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 20:03:50 -0500
Date: 31 Dec 2010 20:03:49 -0500
Message-ID: <20110101010349.12974.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, Trond.Myklebust@netapp.com
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <1293769968.32633.19.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...and your point would be that an exponentially increasing addition to
> the existing number of tests is an acceptable tradeoff in a situation
> where the >99.999999999999999% case is that of sane servers with no
> looping? I don't think so...

1) Look again; it's O(1) work per entry, or O(n) work for an n-entry
   directory.  And O(1) space.  With very small constant factors, and
   very little code.  The only thing exponentially increasing is the
   interval at which you save the current cookie for future comparison.
2) You said it *was* a problem, so it seemed worth presenting a
   practical solution.  If you don't think it's worth it, I'm not
   going to disagree.  But it's not impossible, or even difficult.
