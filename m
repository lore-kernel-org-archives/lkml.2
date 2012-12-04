Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2LDNu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:50:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56574 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2LDNuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:50:55 -0500
Date: Tue, 4 Dec 2012 10:50:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/18] perf ui/hist: Add support for event group view
Message-ID: <20121204135049.GC3159@ghostprotocols.net>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-14-git-send-email-namhyung@kernel.org>
 <20121130132943.GC1080@krava.brq.redhat.com>
 <20121130135215.GG1957@ghostprotocols.net>
 <CAM9d7cgZMfbYOdcELNXdGPT9tOzbKLZbNWjZ8g3Sug6_88pGnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cgZMfbYOdcELNXdGPT9tOzbKLZbNWjZ8g3Sug6_88pGnA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 04, 2012 at 06:16:59PM +0900, Namhyung Kim escreveu:
> On Fri, Nov 30, 2012 at 10:52 PM, Arnaldo Carvalho de Melo wrote:

> Ah, I missed your point.  Just got it now, will try this approach.  So
> you want to see no "0.00%" for a dummy entry, right?

That wasn't the point, and perhaps printing 0.00% pollutes the screen
needlessly or may be a help in seeing the columns more clearly, no
strong opinion at this point, please experiment.

The point was that there seems to be no need for the temporary array.

- Arnaldo
