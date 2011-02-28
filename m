Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1B1XtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:49:21 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50267 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab1B1XtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:49:19 -0500
Message-ID: <4D6C3461.8010109@dcl.info.waseda.ac.jp>
Date: Tue, 01 Mar 2011 08:48:49 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b10pre) Gecko/20110114 Thunderbird/3.3a2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: fweisbec@gmail.com, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockstat: export data in python expression
References: <4D67E286.8010907@dcl.info.waseda.ac.jp>  <1298905223-1807-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1298916475.5226.850.camel@laptop>
In-Reply-To: <1298916475.5226.850.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年03月01日 03:07, Peter Zijlstra wrote:
> On Tue, 2011-03-01 at 00:00 +0900, Hitoshi Mitake wrote:
>> I'm writing the tool for parsing and arranging the data of /proc/lock_stat
>> in python. But I soon found that lock_stat is hard to parse, so I wrote
>> this patch to let lock_stat output its information in python expression.
>
> _IF_ we're going to do something like this, I'd much prefer a sane
> output format over something that's easily parseble by just one thing.
>
>

Does "by just one thing" mean that the ioctl() for format setting
should not be allowed? I have to admit that this patch adds lots of
ugly if and switch statements. If I have to choose just one style
in order to forbid increasing expressions, I'd like to choose
S-expression because it is easy to parse by any language.
