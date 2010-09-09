Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0IIQsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:48:33 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:47722 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609Ab0IIQsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:48:30 -0400
Subject: Re: [PATCH] perf: Fix crash when vmlinux_path__exit().
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100909164420.GD4155@ghostprotocols.net>
References: <1284043690.2000.8.camel@cowboy>
	 <20100909164420.GD4155@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 12:48:27 -0400
Message-ID: <1284050907.2085.10.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 13:44 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 09, 2010 at 10:48:10AM -0400, Davidlohr Bueso escreveu:
> > [PATCH] perf: Fix crash when vmlinux_path__exit()
> > 
> > When running perf {timechart,sched} record an incorrect freeing occurs after Ctrl-C'ing to
> > exit the application, the following is seen:
> 
> There was a fix for this that just checked if it was already
> initialized, lemme check.

Right, an initialization check would also correct the illegal free. IMO
it would still be appropriate to double check this in
vmlinux_path__init().

> 
> You don't mention what is the git tree you are using or if this is from
> some tarball, can you clarify?
> 
Sorry, this under the latest mainline kernel (last pull was Today). 

Davidlohr


