Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0EYJtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:49:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab0EYJtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:49:20 -0400
Date: Tue, 25 May 2010 10:48:45 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Nikanth Karthikesan <knikanth@suse.de>,
       Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>, dm-devel@redhat.com
Subject: Re: [dm-devel] add devname module aliases to allow module
	on-demand auto-loading
Message-ID: <20100525094845.GA3991@agk-dp.fab.redhat.com>
Mail-Followup-To: Kay Sievers <kay.sievers@vrfy.org>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <chris.mason@oracle.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Ian Kent <raven@themaw.net>, dm-devel@redhat.com
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> <201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com> <20100521182325.GO3991@agk-dp.fab.redhat.com> <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com> <20100525053341.GB31345@maude.comedia.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525053341.GB31345@maude.comedia.it>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 07:33:41AM +0200, Luca Berra wrote:
> what patch?

Peter Rajnoha is working on a final version of this, which includes
tweaking the userspace logic to give supremacy to devtmpfs.

Alasdair

