Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308Ab1LPXuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:50:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55032 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760610Ab1LPXuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:50:11 -0500
Message-ID: <4EEBD92E.7060201@gmail.com>
Date: Fri, 16 Dec 2011 16:50:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH 0/3] perf: working with multithreaded processes with named
 threads
References: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/09/2011 10:43 AM, David Ahern wrote:
> One bug fix plus a couple of enhancements to improve handling of
> named threads.
> 
> David Ahern (3):
>   perf: fix comm for processes with named threads
>   perf: look up thread names for system wide profiling
>   perf script: look up thread using tid instead of pid
> 
>  tools/perf/builtin-script.c |    2 +-
>  tools/perf/util/event.c     |  111 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 85 insertions(+), 28 deletions(-)
> 

Any comments?

David
