Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238Ab0HFL0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:26:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33143 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0HFL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:26:38 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, yhlu.kernel@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] apic: tracing IPI events
References: <1281006578-5073-1-git-send-email-jolsa@redhat.com>
Date: Fri, 06 Aug 2010 13:26:36 +0200
In-Reply-To: <1281006578-5073-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 5 Aug 2010 13:09:36 +0200")
Message-ID: <87bp9gc783.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:
>
> please let me know what you think

You forgot to state why you want it?

In generall the only case that should happen anytime commonly is mask,
the others only for obscure uncommon paths.

However there is already accounting for it in /proc/interrupts
that can be easily sampled. Does adding additional tracing really give 
any value?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
