Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0DUM3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:29:16 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60911 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab0DUM3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:29:13 -0400
Message-ID: <4BCEEF96.3060104@dcl.info.waseda.ac.jp>
Date: Wed, 21 Apr 2010 21:29:10 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Fix state machine to recognize lock sequence
References: <4BC09546.5050309@dcl.info.waseda.ac.jp>	 <1271407446-27180-1-git-send-email-mitake@dcl.info.waseda.ac.jp>	 <20100421012651.GC7120@nowhere> <1271840158.1776.63.camel@laptop>
In-Reply-To: <1271840158.1776.63.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/10 17:55, Peter Zijlstra wrote:
 > On Wed, 2010-04-21 at 03:26 +0200, Frederic Weisbecker wrote:
 >> The max lockdep depth may
 >> change in the future, or become variable, so we can't relay on that.
 >>
 > Change, possible, variable unlikely, you need a memory allocation to
 > extend it, and memory allocation takes locks, which is not a nice thing
 > to do in the middle of lockdep.

Thanks for your clear description.
It seems that we can think that maximum depth of lock will not be variable.

Thanks,
	Hitoshi
