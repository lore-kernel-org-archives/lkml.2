Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2CLWHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab2CLWHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:07:30 -0400
Date: Mon, 12 Mar 2012 23:07:20 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120312220720.GA6720@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E4757.705@redhat.com>
 <20120312190818.GA25523@host2.jankratochvil.net>
 <4F5E526B.2020406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E526B.2020406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 20:45:47 +0100, Denys Vlasenko wrote:
> On 03/12/2012 08:08 PM, Jan Kratochvil wrote:
> >	Try: yum --disablerepo='*' --enablerepo='*-debuginfo' install /usr/lib/debug/.build-id/ec/1fd70dbee0db36eff9527254d9d2bbfd260f13
> 
> My network is down. "yum install" won't work.

You need to fix yum first on each distro so that it works like apt-get does:
	echo 'metadata_expire=never' >>/etc/yum.conf
	echo "yum --enablerepo='*' makecache" >/etc/cron.daily/yumupdate
	chmod +x /etc/cron.daily/yumupdate

Then all the examples I have given work fine.


Regards,
Jan
