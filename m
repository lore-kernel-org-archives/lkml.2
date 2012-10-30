Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab2J3Ope (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:45:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab2J3Opc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:45:32 -0400
Message-ID: <508FE808.2030306@gmail.com>
Date: Tue, 30 Oct 2012 08:45:28 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH 1/9] perf python: add ui stubs file
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com> <1351528309-87705-2-git-send-email-dsahern@gmail.com> <87a9v4777t.fsf@sejong.aot.lge.com>
In-Reply-To: <87a9v4777t.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/12 1:24 AM, Namhyung Kim wrote:
> Hi David,
>
> On Mon, 29 Oct 2012 10:31:41 -0600, David Ahern wrote:
>> stdio based implementations of ui_xxxx based functions for the python
>> library. Needed for patch 3 - consolidating open counters method.
>
> How about adding ui/util.c to the python-ext-sources?

Handles some of the ui_xxxx functions, but still missing some symbols -- 
verbose, eprintf, ui__error_paranoid. The point of the python_stubs.c 
was a short term solution for the ui handlers. Arnaldo had some ideas on 
what is really needed.

David


