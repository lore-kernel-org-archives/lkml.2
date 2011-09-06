Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1IFSjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:39:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49756 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1IFSi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:38:59 -0400
Date: Tue, 6 Sep 2011 15:38:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, anton@samba.org
Subject: Re: [PATCH v4] perf tool: fix endianness handling of u32 data in
 samples
Message-ID: <20110906183851.GB5365@ghostprotocols.net>
References: <1315321946-16993-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315321946-16993-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 06, 2011 at 09:12:26AM -0600, David Ahern escreveu:
> v3 -> v4:
> - fixed use of WARN_ONCE
> 
> v2 -> v3:
> - used WARN_ONCE for message regarding raw data
> - removed struct wrapper around union
> - fixed whitespace issues
> 
> v1 -> v2:
> - added a union for undoing the byte-swap on u64 and redoing swap on
>   u32's to address compiler errors (see git commit 65014ab3)

Thank you, I'm applying this one.

- Arnaldo
