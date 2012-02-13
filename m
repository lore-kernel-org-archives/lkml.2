Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2BMUqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:46:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60502 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab2BMUqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:46:38 -0500
Message-ID: <4F397651.6070409@zytor.com>
Date: Mon, 13 Feb 2012 12:45:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Len Brown <lenb@kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Patrick McHardy <kaber@trash.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Steve French <sfrench@samba.org>,
        Dave Kleikamp <shaggy@kernel.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [RFC] MAINTAINERS: Remove or update no longer existing git trees
References: <1329164739.4939.14.camel@joe2Laptop>
In-Reply-To: <1329164739.4939.14.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 12:25 PM, Joe Perches wrote:
> Many git trees have not been restored to git.kernel.org
> since the interruption of service last year.
>
> Here's a list of currently non-existing kernel.org git
> trees mentioned in MAINTAINERS:
>
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git

Long since obsolete, replaced with the x86/boot branch in the tip tree.

	-hpa

