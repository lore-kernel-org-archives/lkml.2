Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1I1CHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:07:41 -0400
Received: from mout.perfora.net ([74.208.4.194]:58176 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab1I1CHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:07:40 -0400
Date: Tue, 27 Sep 2011 22:07:24 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: x86: add context tag to mark mm when running a task in 32-bit
 compatibility mode
Message-ID: <20110928020724.GA4524@wicker.gateway.2wire.net>
References: <20110927170448.GA15977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927170448.GA15977@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:OjuPfTKs2HvDSn1EYPJ6LWK+1RPEYFqQ+S/9YrQc8Op
 VI+TDtispGDSuH3TLxhTEGI8SIenwBXrqWz1Q4x2hpUCoKYr2d
 l5PhEARJTjaiYzC+uewgoV8+9IYQVlW5SWn0yu4dAmIGzAqbwu
 DYX7MvZQUxFPsv1CkyahOvXvk5YLwPF4AXqa7eMn2WMR8cVnnt
 MI9Sar3r3vP4GXlHZ5+KQiBc11O4Ct/4JkYh++jU/S1NFCIEg9
 n6UK0WeKwShXD49CNEFgoOnJ6By5kyT2StpoiTeCJN5aQCDLcI
 L8ro5TFDUDbiW+TVoyT4rVY/A+ZCJexdSaqnOlLwQEEKvHRwHc
 BjhthmkBMh6d7dEMADRJHrk0ynT+ZIn7OtQbJNs5dRGc1fAVPd
 RpLc3luF+M40w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Sep 27, 2011 at 07:04:48PM +0200, Oleg Nesterov wrote:
> I am asking because we probably want to backport this change and this
> ia32_compat looks a bit annoying, why should we waste a word?
> 
> Sure, this is very minor, but perhaps the trivial patch below makes
> sense?

Definitely makes sense (modulo Al's remarks).


Thanks,

-- 
steve

