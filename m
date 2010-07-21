Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab0GUKRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 06:17:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0GUKR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 06:17:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the suspend tree with the wireless tree
Date: Wed, 21 Jul 2010 12:15:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        "John W. Linville" <linville@tuxdriver.com>
References: <20100721132006.ff026db8.sfr@canb.auug.org.au>
In-Reply-To: <20100721132006.ff026db8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007211215.33596.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 21, 2010, Stephen Rothwell wrote:
> Hi Rafael,

Hi,

> Today's linux-next merge of the suspend tree got a conflict in
> drivers/net/wireless/ipw2x00/ipw2100.c between commit
> d267be307a3345ef06889511cad2aa1fecc83db7 ("ipw2100: mark
> ipw2100_pm_qos_req static") from the wireless tree and commit
> 82f682514a5df89ffb3890627eebf0897b7a84ec ("pm_qos: Get rid of the
> allocation in pm_qos_add_request()") from the suspend tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, please carry the fix, modifying any of the involved trees would make it
depend on the other.

Rafael
