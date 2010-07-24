Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0GXIFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:05:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0GXIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:05:13 -0400
Date: Sat, 24 Jul 2010 10:04:59 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: jmoyer@redhat.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] cfq-iosched: don't allow aliased requests to starve
 others
Message-ID: <20100724080459.GA6500@fancy-poultry.org>
References: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:YFfpAo1ON7QMKrNqXeDM95V46zs9Y9vg9IsDjFvLqGU
 1NKUP354qUjPJsusyC7L8l2dUGrnZgaZIDmZUW7QN8G8oCn33X
 2zb5NHlcjzXv/+PAi47+2tcXB/G4RgqAHz4XMZ/6Ct4reL0pJA
 3rZXTvErPZCETQPJ9uVYFuBfLFwC4d0H10YOHO8ucxMyRZf+WS
 Oh226EHmXazF2+vPbYlkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.07.2010, Jeff Moyer wrote: 

> Comments, as always, are welcome.

This patch, applied to 2.6.35-rc6, increases desktop interactivity
_NOTICEABLY_ on my quadcore machine, and the machine stays rock-stable.
I have now tested this patch with the latest 2.6.35-rc kernels over 
1 week.

Unfortunately, I can't provide some testing results which makes this
statement more objective, but I'll do some synthetic testing in the next
days.

