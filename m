Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414Ab2BOAtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 19:49:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33856 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab2BOAtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 19:49:39 -0500
Date: Tue, 14 Feb 2012 16:49:20 -0800
From: Kees Cook <kees@outflux.net>
To: Joe Perches <joe@perches.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 4/8] seccomp: Add SECCOMP_RET_TRAP
Message-ID: <20120215004920.GP20420@outflux.net>
References: <1328935151-6908-1-git-send-email-wad@chromium.org>
 <1328935151-6908-5-git-send-email-wad@chromium.org>
 <CAObL_7FJ=a-X0UuVuK1p338nAVCes4H8PTe2ji5dOLhrtSaKHQ@mail.gmail.com>
 <CABqD9hYipmC1Dcx6+VrDM04ik5ysfw0GCypEzdFDBfh5B24jtA@mail.gmail.com>
 <20120211200346.GA16870@albatros>
 <1328991543.11026.8.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328991543.11026.8.camel@joe2Laptop>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 12:19:03PM -0800, Joe Perches wrote:
> On Sun, 2012-02-12 at 00:03 +0400, Vasiliy Kulikov wrote:
> > On Sat, Feb 11, 2012 at 13:30 -0600, Will Drewry wrote:
> > > (As a side note, I realize the CC list has ballooned.  In the next
> > > rev, I'll pare it down to active participants and the appropriate
> > > lists and not just the get_maintainers.pl output!)
> > Add kernel-hardening to CC and remove me and Kees ;)
> 
> Should that list be added to MAINTAINERS or
> Documentation/ somewhere?

FWIW, I like getting direct emails in addition to the mailing list emails.

-Kees

-- 
Kees Cook                                            @outflux.net
