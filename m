Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab2HUVgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:36:41 -0400
Received: from mout.perfora.net ([74.208.4.194]:50240 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448Ab2HUVgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:36:39 -0400
Date: Tue, 21 Aug 2012 17:22:27 -0400
From: Jim Rees <rees@umich.edu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120821212227.GA14194@umich.edu>
References: <20120821212910.GD18637@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821212910.GD18637@fieldses.org>
X-Provags-ID: V02:K0:IPR7h/3v7t1kmVTCOrGhguC82mNJXoQESzwxkeviRpe
 2VpJc/CaZzt1meLNLfcnrsQOjuR6mqWrAhnYhZo5DIdnPr2E/+
 uM5MvIdDjtvaij3cRVsNnXP2N+cALWmRlqCnM6F9N8tvIeWt7c
 eS0WORzDJigOrLvn9h2sv291VtjdRze4ST03tMgsjNV3WcdYML
 dnQ5tdgDi55crg6ikK4TssVN+2XxI9KiGPlPT297HY2pivGGpc
 4k3K9cHTuekE6XCU146Idif3zpDlfkaFOsBcHZqJE9G9mWenFX
 2B6Hr20N2yyQERckGvSiitpm0gZqfgDtD/YeM72k+43mC7JlA=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:

  From: "J. Bruce Fields" <bfields@redhat.com>
  
  I've seen a couple examples recently where we've gotten this wrong.
  Maybe something like this would help?  Is there some better way?
  
  (Approximation due to Jim Rees).

Please add Suggested-by: Jim Rees <rees@umich.edu>.  I'm thinking of
patenting the algorithm.
