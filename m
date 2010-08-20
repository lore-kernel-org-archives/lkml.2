Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0HTJXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:23:12 -0400
Received: from mx2.sophos.com ([195.166.81.53]:58873 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0HTJXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:23:10 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: struct fanotify_event_metadata
Date: Fri, 20 Aug 2010 10:23:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <m21va1ozqx.fsf@igel.home> <201008201002.16235.tvrtko.ursulin@sophos.com> <m3pqxd7ift.fsf@hase.home>
In-Reply-To: <m3pqxd7ift.fsf@hase.home>
MIME-Version: 1.0
Message-ID: <201008201023.07316.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/08/2010 10:23:07,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/08/2010 10:23:08,
	Serialize complete at 20/08/2010 10:23:08
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 Aug 2010 10:16:22 Andreas Schwab wrote:
> Tvrtko Ursulin <tvrtko.ursulin@sophos.com> writes:
> > Shrink pid field in the fanotify_event_metadata to 32-bit to match
> > the kernel representation. Pull mask field up since it logically
> > comes before event auxiliary data and also makes for a nicer
> > alignment.
>
> That won't buy you much wrt. alignment though, due to the packed
> attribute.

I know, it is primarily more logical ordering of fields withing the event. It
is only secondary that I thought it is nicer to have 32-32-64-32-32 than,
32-32-32-64-32, maybe there is some platform where it is nicer?

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
