Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2GaJAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:00:45 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59883 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab2GaJAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:00:43 -0400
Date: Tue, 31 Jul 2012 13:00:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "criu@openvz.org" <criu@openvz.org>,
        "users@openvz.org" <users@openvz.org>,
        Containers <containers@lists.linux-foundation.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
Message-ID: <20120731090039.GB2396@moon>
References: <500D09C9.7060903@parallels.com>
 <500D1116.7070301@parallels.com>
 <CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
 <50179CF0.7050200@parallels.com>
 <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:57:58AM +0200, richard -rw- weinberger wrote:
> >
> >> crtools seem to use ptrace() to execute parasite system calls.
> >> AFAIK this will only work if the target process is currently not
> >> ptraced() by another process.
> >>
> >
> > Yup, exactly.
> 
> Dammit, I hoped we can get suspend/resume for UserModeLinux for free
> with CRIU. 8-)

We have plans to implement seizing on traced tasks but no dates at the moment ;)

	Cyrill
