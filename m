Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab2J3NbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:31:09 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45498 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2J3NbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:31:07 -0400
Message-ID: <508FD697.4000804@gmail.com>
Date: Tue, 30 Oct 2012 07:31:03 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH 2/9] perf top: make use of perf_record_opts
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com> <1351528309-87705-3-git-send-email-dsahern@gmail.com> <87625s772z.fsf@sejong.aot.lge.com>
In-Reply-To: <87625s772z.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/12 1:27 AM, Namhyung Kim wrote:
> On Mon, 29 Oct 2012 10:31:42 -0600, David Ahern wrote:
>> Changes top code to use the perf_record_opts struct. Stepping stone to
>> consolidating the open counters code.
>
> Maybe time to rename perf_record_opts to perf_open_opts or just perf_opts?

It's still the record time opts. Either way, a rename is for a different 
patch series.

David

