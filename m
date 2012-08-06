Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887Ab2HFEOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:14:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2HFEOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:14:50 -0400
Message-ID: <501F44B2.4010703@gmail.com>
Date: Sun, 05 Aug 2012 22:14:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 03/18] perf target: Fix check on buffer size
References: <1344002470-5965-1-git-send-email-acme@infradead.org> <1344002470-5965-4-git-send-email-acme@infradead.org> <20120803141703.GA19736@shutemov.name> <87vcgwznen.fsf@sejong.aot.lge.com>
In-Reply-To: <87vcgwznen.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/12 9:53 PM, Namhyung Kim wrote:
>
> I think this should go to the urgent branch too as the offending patch
> seemed to go to the mainline already.
>

It was picked up by Ingo today and included in his pull request sent to 
Linus.

David

