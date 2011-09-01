Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1IAQyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:54:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab1IAQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:54:12 -0400
Message-ID: <4E5FB8B0.30507@gmail.com>
Date: Thu, 01 Sep 2011 10:54:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, anton@samba.org
Subject: Re: [PATCH] perf tool: fix endianness handling of u32 data in samples
References: <1314654924-13071-1-git-send-email-dsahern@gmail.com> <20110901161900.GB15984@ghostprotocols.net> <4E5FB5D6.1080209@gmail.com>
In-Reply-To: <4E5FB5D6.1080209@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 10:41 AM, David Ahern wrote:
> That's no good. It compiles cleanly on Fedora 15-x86 and Fedora 12-ppc.
> What version of gcc is this?

hmm.... correction, fails on F12. I guess I only tested the swap code on
x86 running F15. I'll investigate.

David


