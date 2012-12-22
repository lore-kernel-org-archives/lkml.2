Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2LVCZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:25:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45109 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2LVCZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:25:30 -0500
Date: Fri, 21 Dec 2012 21:24:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v6 03/27] x86, boot: move verify_cpu.S and no_longmode
 after 0x200
Message-ID: <20121222022456.GE3468@phenom.dumpdata.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-4-git-send-email-yinghai@kernel.org>
 <20121215170625.GA9875@liondog.tnic>
 <CAE9FiQUSoSvtFMMQt3eZkrXFCkzXhLu6GfqYMGNb3=uA052Axw@mail.gmail.com>
 <20121219205732.GI24895@liondog.tnic>
 <CAE9FiQXOV-GZk6HR17KcDsiPM89=eNHdYRSP2A6n5R_AKnhaLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXOV-GZk6HR17KcDsiPM89=eNHdYRSP2A6n5R_AKnhaLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 01:58:57PM -0800, Yinghai Lu wrote:
> On Wed, Dec 19, 2012 at 12:57 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Tue, Dec 18, 2012 at 07:44:55PM -0800, Yinghai Lu wrote:
> >
> > So this explains what you're doing but I'd like to know why?
> >
> > Why do you need to free some more room between startup_32 and
> > startup_64? Do you need this room in another patch, maybe the next one:
> >
> > "[PATCH v7 14/27] x86, boot: Move lldt/ltr out of 64bit code section"
> >
> > Is that so? If yes, please write that in the commit message so that we
> > know why you're doing that change.
> 
> duplicate next patch commit log here. no, that's too long.

Why is that a problem? Long patch commit logs are OK.
