Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2LFN2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:28:17 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:42622 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2LFN2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 08:28:16 -0500
Subject: Re: [PATCH] perf diff: Removing displacement output option
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20121206132228.GB1080@krava.brq.redhat.com>
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
	 <1354690603-31364-3-git-send-email-namhyung@kernel.org>
	 <20121205190646.GB1037@krava.brq.redhat.com>
	 <20121205191209.GE6629@ghostprotocols.net>
	 <20121206132228.GB1080@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Dec 2012 22:28:08 +0900
Message-ID: <1354800488.1782.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-12-06 (목), 14:22 +0100, Jiri Olsa:
> On Wed, Dec 05, 2012 at 04:12:09PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Dec 05, 2012 at 08:06:46PM +0100, Jiri Olsa escreveu:
> > > However, I wonder if anyone is actualy using displacement info..?
> > 
> > IIRC that was used long ago in the first version of 'perf diff', that
> > is not the default, probably we can just ditch it to simplify things,
> > can you check?
> 
> you're right, it's there since vert beggining.. and now it's gone ;) attached

Good, I'll send v3 soon based on this.

Thanks,
Namhyung


