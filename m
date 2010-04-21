Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0DUQKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:10:21 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64876 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab0DUQKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:10:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dJ2/fj3F52CyeV7JcEt+YpWMIP8+u6PGHfDvp5hagVWl6xfz9LxqY+sq27gjx9xUha
         YMyGQkbdf5/d9CRG+ZkzIlGPCYmqsFDjRRnmuImRCbqD6Nt6a2lRus5qgLOAHdHTBLQm
         5kgpiLjcRnzgABtIlRwgByQjQPdF6m/koE0qU=
Date: Wed, 21 Apr 2010 18:10:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Fix state machine to recognize lock sequence
Message-ID: <20100421161015.GA5650@nowhere>
References: <4BC09546.5050309@dcl.info.waseda.ac.jp> <1271407446-27180-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100421012651.GC7120@nowhere> <1271840158.1776.63.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271840158.1776.63.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 10:55:58AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-04-21 at 03:26 +0200, Frederic Weisbecker wrote:
> > The max lockdep depth may
> > change in the future, or become variable, so we can't relay on that.
> > 
> Change, possible, variable unlikely, you need a memory allocation to
> extend it, and memory allocation takes locks, which is not a nice thing
> to do in the middle of lockdep.


Sure, I didn't meant on runtime but on boot, like in John's recent
proposal.

Thanks.

