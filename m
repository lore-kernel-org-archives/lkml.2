Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1LSVZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:25:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44041 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1LSVZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:51 -0500
Message-ID: <4EEFABD9.9050203@gmail.com>
Date: Mon, 19 Dec 2011 14:25:45 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Andrew Vagin <avagin@gmail.com>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, asharma@fb.com, devel@openvz.org,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 3/6] perf: add ability to record event period
References: <1323266161-394927-1-git-send-email-avagin@openvz.org> <1323266161-394927-4-git-send-email-avagin@openvz.org> <4EEAEF83.3080100@gmail.com> <20111219205829.GB28058@infradead.org>
In-Reply-To: <20111219205829.GB28058@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 01:58 PM, Arnaldo Carvalho de Melo wrote:
> I get that Arun is in agreement, everything seems OK, but we need to do
> a better job on describing why we add code, the context we have now from
> all these discussions will be mostly lost, say, 5 years from now when we
> try to figure out why something was done in some way,

It seems like an option is needed for all the sample attributes.
Timestamp is now covered (-T). Sample address is covered (-d). Callchain
(-g). This targets period (-P). I think that just leaves CPU, and we are
out of c/C options. ;-)

David
