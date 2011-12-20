Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1LTN0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:26:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:57426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1LTN0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:26:18 -0500
Date: Tue, 20 Dec 2011 11:26:03 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andrew Vagin <avagin@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        asharma@fb.com, devel@openvz.org, dsahern@gmail.com,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 3/6] perf: add ability to record event period
Message-ID: <20111220132603.GD28058@infradead.org>
References: <1323266161-394927-1-git-send-email-avagin@openvz.org>
 <1323266161-394927-4-git-send-email-avagin@openvz.org>
 <4EEAEF83.3080100@gmail.com>
 <20111219205829.GB28058@infradead.org>
 <4EF0424D.3070102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF0424D.3070102@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 20, 2011 at 12:07:41PM +0400, Andrew Vagin escreveu:
> On 12/20/2011 12:58 AM, Arnaldo Carvalho de Melo wrote:
> >Em Fri, Dec 16, 2011 at 11:13:07AM +0400, Andrew Vagin escreveu:
> >>Hi Arnaldo,
> >>
> >>Could you review and commit this patch. It's quite common
> >>functionality, which allow to get events more effectively and to
> >>avoid losing events.
> >>
> >>All other patches may be postponed, because Arun Sharma wants to
> >>suggest your version of "Profiling sleep times".
> >It would help if you provided a more detailed patch description, this
> >one came with just a title :-\
> Look at the comment below. In it I try describe why we need this
> functionality.

Much better, please now resubmit the patch with that explanation.

Thanks,

- Arnaldo
