Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2LXODv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 09:03:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2LXODs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 09:03:48 -0500
Date: Mon, 24 Dec 2012 15:03:24 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/3] Revert "perf: Require exclude_guest to use PEBS -
 kernel side enforcement"
Message-ID: <20121224140324.GA1171@krava.redhat.com>
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
 <1355929642-28392-2-git-send-email-jolsa@redhat.com>
 <50D60833.7040106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D60833.7040106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 12:21:23PM -0700, David Ahern wrote:
> On 12/19/12 8:07 AM, Jiri Olsa wrote:
> >This reverts commit 20b279ddb38ca42f8863cec07b4d45ec24589f13.
> >
> >Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> >Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >Cc: Ingo Molnar <mingo@elte.hu>
> >Cc: Namhyung Kim <namhyung@kernel.org>
> >Cc: Paul Mackerras <paulus@samba.org>
> >Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> As a courtesy please CC people involved in a commit on any revert request.
> 
> Arnaldo: please do not take this patch; I have proposed an
> alternative. Just waiting to hear back on its acceptability.
> 
> David

this one was not meant to be applied.. just wanted the precise
to work, so I could test other stuff.. I did mention that in:

  [RFC 0/3] perf tests: Adding precise event attribute test
  ---
  I based this on revert (Patch 1) discussed in [1]. I'm not sure
  this revert will tak place at the end, but I wanted to get some
  feedback on the 'precise' attribute first.
  ...
  [1] http://marc.info/?l=linux-kernel&m=135536724805356&w=2
  ---

jirka
