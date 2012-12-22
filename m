Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2LVT1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:27:34 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63335 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2LVT1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:27:31 -0500
Message-ID: <50D60833.7040106@gmail.com>
Date: Sat, 22 Dec 2012 12:21:23 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/3] Revert "perf: Require exclude_guest to use PEBS -
 kernel side enforcement"
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com> <1355929642-28392-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355929642-28392-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/12 8:07 AM, Jiri Olsa wrote:
> This reverts commit 20b279ddb38ca42f8863cec07b4d45ec24589f13.
>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

As a courtesy please CC people involved in a commit on any revert request.

Arnaldo: please do not take this patch; I have proposed an alternative. 
Just waiting to hear back on its acceptability.

David
