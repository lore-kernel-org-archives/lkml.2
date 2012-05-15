Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab2EOByt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:54:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42234 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab2EOBys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:54:48 -0400
Message-ID: <4FB1B764.2060802@gmail.com>
Date: Mon, 14 May 2012 19:54:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>, linux-kernel@vger.kernel.org,
        Lucas Meneghel Rodrigues <lmr@redhat.com>
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com> <87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com> <87k40e1cco.fsf@sejong.aot.lge.com> <4FB1B486.4020509@gmail.com> <20120515014633.GD4254@infradead.org>
In-Reply-To: <20120515014633.GD4254@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/12 7:46 PM, Arnaldo Carvalho de Melo wrote:
> And we need to have all this logic in a central place, the "open" method
> of perf_evlist :-)
>
> The perf_target abstraction is the way to get there, but in the process
> I think we really need to have each new method with a 'perf test' entry
> and in addition to that an 'autotest'* entry to test the perf builtins.
>
> - Arnaldo
>
> * http://autotest.github.com/

Yes, I've seen the project and know that kvm leverages the framework. My 
knowledge ends there - never had a reason to try it out. With the vPMU 
in v3.3 we could use KVM to automate a fair bit of the testing.

David
