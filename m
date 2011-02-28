Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1B1SHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:07:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:48931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1B1SHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:07:03 -0500
Subject: Re: [PATCH] lockstat: export data in python expression
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1298905223-1807-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <4D67E286.8010907@dcl.info.waseda.ac.jp>
	 <1298905223-1807-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 19:07:55 +0100
Message-ID: <1298916475.5226.850.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 00:00 +0900, Hitoshi Mitake wrote:
> I'm writing the tool for parsing and arranging the data of /proc/lock_stat
> in python. But I soon found that lock_stat is hard to parse, so I wrote
> this patch to let lock_stat output its information in python expression.

_IF_ we're going to do something like this, I'd much prefer a sane
output format over something that's easily parseble by just one thing.

