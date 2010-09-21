Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0IUCph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:45:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51423 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0IUCpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:45:36 -0400
Message-ID: <4C981BC4.90405@zytor.com>
Date: Mon, 20 Sep 2010 19:43:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 08/10] jump label v11: x86 support
References: <cover.1284733808.git.jbaron@redhat.com> <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
In-Reply-To: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 08:09 AM, Jason Baron wrote:
> add x86 support for jump label. I'm keeping this patch separate so its clear to
> arch maintainers what was required for x86 support this new feature. hopefully,
> it wouldn't be too painful for other arches.

> +	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE

Why?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

