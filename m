Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2F0QOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:14:08 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58818 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751546Ab2F0QOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:14:04 -0400
Message-ID: <4FEB312D.5020608@xenotime.net>
Date: Wed, 27 Jun 2012 09:13:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Joe Thornber <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: linux-next: Tree for Jun 27 (dm-thin.c)
References: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
In-Reply-To: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 08:22 PM, Stephen Rothwell wrote:

> Hi all,
> 
> This tree was not built between each merge, but only after merging all
> the trees.
> 
> Changes since 20120626:
> 
> The device-mapper tree gained a build failure for which I reverted a
> commit.


on x86_64:

drivers/md/dm-thin.c: In function 'pool_preresume':
drivers/md/dm-thin.c:2129:3: warning: format '%llu' expects type 'long long unsigned int', but argument 2 has type 'sector_t'


CONFIG_LBDAF is not enabled.


-- 
~Randy
