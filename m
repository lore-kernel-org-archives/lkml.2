Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2ALRet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:34:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:34:46 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=mFiD4lpLg54A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=kxTwD1JPn5JNYPxYDAgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326389682.7642.109.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2 2/2] Documentation: prctl/seccomp_filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net
Date: Thu, 12 Jan 2012 12:34:42 -0500
In-Reply-To: <CABqD9haEB8OFxKht0u7hiHoQf+_xZL=Y8nFYKUb6DxonR9w6UQ@mail.gmail.com>
References: <CABqD9hbQRinbYqqwjqH8TfDvkOpESwiCp1uEE8d0Q7Rp4tsM0A@mail.gmail.com>
	 <1326323983-23630-1-git-send-email-wad@chromium.org>
	 <4F0F238E.7020508@xenotime.net>
	 <CABqD9haEB8OFxKht0u7hiHoQf+_xZL=Y8nFYKUb6DxonR9w6UQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 11:23 -0600, Will Drewry wrote:

> > Please tell some of us what "BPF" means.  wikipedia lists 15 possible
> > choices, but I don't know which one to choose.
> 
> I'll make it clearer in the documentation file and update the patch description.
> 
> BPF == Berkeley Packet Filters which are implemented in Linux Socket
> Filters (LSF)>
> 

I admit, I was totally clueless in what it meant too ;)

Even the LWN article didn't explain (shame on you Jon).

"he has repurposed the networking layer's packet filtering mechanism
(BPF)"

I didn't know what did the "B" stood for.

-- Steve


