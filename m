Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0K2RWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:22:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0K2RWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:22:14 -0500
Message-ID: <4CF3E13D.7040204@redhat.com>
Date: Mon, 29 Nov 2010 19:22:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] Don't spam trace report about missing fields
References: <1291047601-13879-1-git-send-email-avi@redhat.com> <1291048005.30543.731.camel@gandalf.stny.rr.com>
In-Reply-To: <1291048005.30543.731.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 06:26 PM, Steven Rostedt wrote:
> On Mon, 2010-11-29 at 18:20 +0200, Avi Kivity wrote:
> >  Instead of spamming the output with complaints about missing fields, simply
> >  return an error to the caller, which can print something out or do something
> >  more intelligent about them.
> >
> >  Fixes kvm plugin tracing older kernels.
>
> Hmm, what about just passing in err=0?

I was just patching the printk out it mindlessly.  Will send a new patch.

-- 
error compiling committee.c: too many arguments to function

