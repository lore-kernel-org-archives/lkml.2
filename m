Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0IXSAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:00:06 -0400
Received: from claw.goop.org ([74.207.240.146]:48030 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0IXSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:00:05 -0400
Message-ID: <4C9CE723.5090308@goop.org>
Date: Fri, 24 Sep 2010 11:00:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Pawe=B3_Zuzelski?= <pawelz@pld-linux.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
        lkml <linux-kernel@vger.kernel.org>,
        James Dingwall <james.dingwall@amdocs.com>
Subject: Re: [Xen-devel] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
 after	the boot
References: <20100921190525.GD4573@davabel.touk.pl> <4C9BEA8C.2030808@goop.org> <20100924054000.GA4689@pzz.touk.pl>
In-Reply-To: <20100924054000.GA4689@pzz.touk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/23/2010 10:40 PM, Pawe³ Zuzelski wrote:
> Have you seen the message from James Dingwall?
>
> He had found the typo in fb412a178502dc498430723b082a932f797e4763
> commit and sent the patch to lkml that fixes it.
>
> Please, see https://patchwork.kernel.org/patch/202282/ if you have
> not received James' mail. That patch resolves the problem for me and
> for James.
>

(!) Oh, well.  Yes, that would explain it. I'd noticed the missing 'x',
but assumed I'd just done it with an editor fat-finger...

Looks like upstream is OK, so it crept in with the stable
cherry-pick/backport to both stable-2.6.32/master and stable-2.6.35/master.

    J
