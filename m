Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2ECUe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:34:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680Ab2ECUe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:34:28 -0400
Message-ID: <4FA2EBCC.5060905@gmail.com>
Date: Thu, 03 May 2012 14:34:20 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/13] perf target: Introduce perf_target_errno
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com> <1335417327-11796-10-git-send-email-namhyung.kim@lge.com> <20120502185913.GE5745@infradead.org>
In-Reply-To: <20120502185913.GE5745@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/12 12:59 PM, Arnaldo Carvalho de Melo wrote:
> Also it would be better to have it as PERF_ERRNO__PID_OVERRIDE_CPU, etc.

I thought you wanted subsystem based errno's (PERF_TARGET__XXXXX) versus 
one big set (PERF_ERRNO__XXXXX). Did you change your mind?

David

