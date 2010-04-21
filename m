Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0DUQN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:13:57 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:35818 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab0DUQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EUMLgvUip6tA9TwxFRXX69DaUV7IZ0KAN7Q9Z2kkhUlZqHMDJ4z6jDEpgh8Kt1PIxT
         kBI4BwTvIeEnpiKAFYmeLkm1WAoBo0qdNsnYkfF4KT3wNwWyMLgrlhaKGtOc3S254hgC
         LdB+a9YLJS1LnbpRBrr9TfTvT5hDVETC3UBeg=
Date: Wed, 21 Apr 2010 18:14:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Fix state machine to recognize lock sequence
Message-ID: <20100421161359.GC5650@nowhere>
References: <4BC09546.5050309@dcl.info.waseda.ac.jp> <1271407446-27180-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100421012651.GC7120@nowhere> <4BCEC166.50207@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCEC166.50207@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 06:12:06PM +0900, Hitoshi Mitake wrote:
> On 04/21/10 10:26, Frederic Weisbecker wrote:
> > 2) I can't get lock_acquired traces. Not sure why yet...
>
> Really? It's mystery... I'll seek the cause.


In fact they are here, but not displayed in perf trace because
of a format file parse error. I'm investigating, I think it
doesn't impact perf lock though.

Thanks.

