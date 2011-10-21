Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1JUPYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 11:24:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64127 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab1JUPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 11:24:04 -0400
Date: Fri, 21 Oct 2011 13:23:57 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@elte.hu, anton@samba.org, daahern@cisco.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/perf: Increase symbol KSYM_NAME_LEN size
Message-ID: <20111021152357.GA2320@ghostprotocols.net>
References: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
 <CAOJsxLGZLx-Wybi=BM41pN5X5Xw=qw4dEC_q=Qy903GpKj6Nzw@mail.gmail.com>
 <20111020081451.GC14464@moon>
 <CAPybu_3kqqtfv1XyhruS3AMiRbd=wdMUr4rJL1UmDG_+z2m9jA@mail.gmail.com>
 <CAOJsxLEY2YJv5G7nRKzM4UowVpPQrXKzmzP6eVShaXFYDySZ2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEY2YJv5G7nRKzM4UowVpPQrXKzmzP6eVShaXFYDySZ2A@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 20, 2011 at 12:14:06PM +0300, Pekka Enberg escreveu:
> On Thu, Oct 20, 2011 at 11:45 AM, Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:
> > and it has worked at least until t^16384 both in gcc and in gdb, and I
> > guess it would have continue working until much more.
> >
> > Right now, I think we can increase it until 512, to be on the safe
> > side, and keep it simple. What do you think?
> 
> If the limit is really 4G, I'm fine with whatever is the smallest
> practical size. If 256 bytes works for you:
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>

Thanks guys, will apply the first patch, bumping it to 256.

- Arnaldo
