Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1DGP73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:59:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56981 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab1DGP72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:59:28 -0400
Message-ID: <4D9DDF43.8080604@zytor.com>
Date: Thu, 07 Apr 2011 08:58:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
References: <4D9CE4AE.4090303@zytor.com> <20110407152800.GA19652@merkur.ravnborg.org>
In-Reply-To: <20110407152800.GA19652@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 08:28 AM, Sam Ravnborg wrote:
> 
> If use of this grows outside plain linux-kernel development a
> more generic name could make sense.
> 
> Suggestion:
> 
>     http://mid.kernel.org/r/message-id
> 
> mid for message-id.
> 

I explicitly did not want to do that, since I believe it is important
information "which mailing list does this come from".  Otherwise we may
need a database on kernel.org knowing exactly which mailing list any
particular message-id belongs to.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

