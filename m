Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2HVAEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 20:04:08 -0400
Received: from mout.perfora.net ([74.208.4.195]:54185 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2HVAEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 20:04:06 -0400
Date: Tue, 21 Aug 2012 20:03:57 -0400
From: Jim Rees <rees@umich.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120822000357.GA18974@umich.edu>
References: <20120821212910.GD18637@fieldses.org>
 <20120821212227.GA14194@umich.edu>
 <20120821220613.GK23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821220613.GK23464@ZenIV.linux.org.uk>
X-Provags-ID: V02:K0:pNDC3rcdjBKz5l9MLiOMsU/KoXwNZEmWsN5I84DKceO
 mhTb62SG6ngVfLYUOiQd9Fxsd4/HZdcBfBWIUETACjoR3MdvXu
 FNo6Y6vNEvLS7R2ygvQU+kTZt6evxNPQDqTX7870g4fSO9BjA9
 LM1JzRPTZQPMuGxR57Piu8sETXp1SWcM6C0yYot/gzNYD/jHoo
 MANtdgqbLQ7BkuTBnYnRcfvkGMo/3HGzpgM64yhOQWYw+O0NU9
 Ldcx08cA8isLor66u21pbUYViktgpyKg9Q8JlGYkX7Ug3uk9On
 SvSJi1wNrWReg/wfHLQS/v/o18IzfH+d2yHb4K7N6/yXX6v5Q=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:

  On Tue, Aug 21, 2012 at 05:22:27PM -0400, Jim Rees wrote:
  > J. Bruce Fields wrote:
  > 
  >   From: "J. Bruce Fields" <bfields@redhat.com>
  >   
  >   I've seen a couple examples recently where we've gotten this wrong.
  >   Maybe something like this would help?  Is there some better way?
  >   
  >   (Approximation due to Jim Rees).
  > 
  > Please add Suggested-by: Jim Rees <rees@umich.edu>.  I'm thinking of
  > patenting the algorithm.
  
  Is that a joke?

Yes, that's a joke.  Sorry if it wasn't obvious.

I am, however offering up licenses at a cost of one pint of beer per
thousand digits converted.
