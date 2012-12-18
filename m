Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2LSMyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:54:52 -0500
Received: from mail-gg0-f182.google.com ([209.85.161.182]:36608 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2LSMys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:54:48 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 07:54:48 EST
Date: Tue, 18 Dec 2012 16:30:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/14] perf ui/hist: Add support for event group view
Message-ID: <20121218193015.GA2639@ghostprotocols.net>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355726345-29553-8-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 17, 2012 at 03:38:58PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Show group members' overhead also when showing the leader's if event
> group is enabled.  Use macro for defining hpp functions which looks
> almost identical.
> 
> Thanks to Arnaldo for suggesting a better way to print group members
> without allocating temporary array.

I applied up to the previous patch (6/14), doing minor changes in some
due to clashes with other patches, but then this one isn't applying, can
you take a look?

I left what I did on the perf/group, so you can continue from there.

- Arnaldo
