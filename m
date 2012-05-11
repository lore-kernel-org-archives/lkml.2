Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab2EKXV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:21:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41585 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752911Ab2EKXV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:21:27 -0400
Message-ID: <1336778486.16292.0.camel@joe2Laptop>
Subject: Re: [PATCH 0/2] Add and use vsprintf extension %pMbt for bluetooth
 macs
From: Joe Perches <joe@perches.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 16:21:26 -0700
In-Reply-To: <20120509090156.GB8473@aemeltch-MOBL1>
References: <cover.1291419007.git.joe@perches.com>
	 <20120509090156.GB8473@aemeltch-MOBL1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 12:01 +0300, Andrei Emeltchenko wrote:
> Hi Joe
> 
> On Fri, Dec 03, 2010 at 06:33:02PM -0800, Joe Perches wrote:
> > Using vsprintf extensions can save text and data.
> > Add %pMbt for the byte reversed output for bluetooth addresses.
> > 
> > Joe Perches (2):
> >   vsprintf: Add %pMbt, bluetooth mac address
> >   bluetooth: Use printf extension %pMbt
> 
> I think this would be the best way to solve our issues with batostr.
> 
> BTW: What is the status with this patch series?

18 month old patches generally don't apply.

If you want to bring it forward or redo it,
please do.

