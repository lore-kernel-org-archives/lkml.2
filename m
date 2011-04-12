Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1DLMPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:15:35 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:43911 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1DLMPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:15:34 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: O_EXCL in NFSv3
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1302609371.10760.6.camel@lade.trondhjem.org>
References: <20361.1302593733@jrobl> <1302609371.10760.6.camel@lade.trondhjem.org>
Date: Tue, 12 Apr 2011 21:15:05 +0900
Message-ID: <28433.1302610505@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trond Myklebust:
> Doesn't commit 8a0eebf66e3b1deae036553ba641a9c2bdbae678 (NFS: Fix NFSv3
> exclusive open semantics) fix this? It should be in the stable tree.

Ah, I can see the commit in v2.6.38.
So it is fixed already, sorry.
I just skipped all NFS tests for v2.6.38. due to the sillyrename
problem.
Also I know it was fixed just after v2.6.38(.0).

Thank you
J. R. Okajima
