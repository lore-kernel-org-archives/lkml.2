Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2D0QAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:00:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53127 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2D0QAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:00:35 -0400
Date: Fri, 27 Apr 2012 13:00:40 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
Message-ID: <20120427160040.GD27997@infradead.org>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
 <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
 <4F996433.7040003@gmail.com>
 <1335474778.1497.14.camel@leonhard>
 <4F99BCAF.1080309@gmail.com>
 <87397qhvvx.fsf@sejong.aot.lge.com>
 <20120427150821.GA27997@infradead.org>
 <4F9ABBF9.8080409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9ABBF9.8080409@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 09:32:09AM -0600, David Ahern escreveu:
> On 4/27/12 9:08 AM, Arnaldo Carvalho de Melo wrote:
> >Ok, after this discussion, David, can I have your acked-by or tested-by?
 
> I had reviewed the whole series yesterday, so you can add my
 
> Reviewed-by: David Ahern <dsahern@gmail.com>
 
> to the whole series if you want. I did not pull down the set and
> apply to test it, and this particular patch requires prior ones so I
> have not tested it.

Fair enough, I'll add the Reviewed-by tag.

I'm running 'perf test' after each patch. Doing it as root, but we need
to automate this to do it as root, user, and user with each of the
paranoid levels...

- Arnaldo
