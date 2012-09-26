Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2IZBYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 21:24:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43485 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2IZBYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 21:24:07 -0400
Message-ID: <50625934.2070707@gmail.com>
Date: Tue, 25 Sep 2012 19:24:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        peterz@infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v3] perf: precise mode and exclude_guest
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12 2:59 PM, David Ahern wrote:
> Hopefully this wraps up the precise mode-exclude_guest dependency.
> I'm sure someone will let me know if I screwed up the attribution
> in the second patch.
>
> David Ahern (2):
>    perf tool: precise mode requires exclude_guest
>    perf tool: give user better message if precise is not supported
>
> Peter Zijlstra (1):
>    perf: require exclude_guest to use PEBS - kernel side enforcement
>
> v3: removed extra tab in patch 2
> v2: updated commit messages for patches 1 and 2

Ping? Is this version Peter approved?

David

