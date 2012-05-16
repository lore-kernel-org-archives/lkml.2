Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab2EPTiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:38:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35404 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab2EPTiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:38:07 -0400
Date: Wed, 16 May 2012 16:38:00 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-05-16
Message-ID: <20120516193800.GG1414@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120516155340.GC1414@joana>
 <20120516180924.GA28167@tuxdriver.com>
 <20120516192431.GE1414@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516192431.GE1414@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gustavo Padovan <gustavo@padovan.org> [2012-05-16 16:24:31 -0300]:

> > What did you do here?  I thought that maybe you had pulled from the
> > wireless tree, but the commit ID is different.
> 
> I did pull from there, actually bluetooth tree, but they have the same head
> now. Something went wrong in the process of re-doing the tree. Sorry for waste
> you time here, John.
> 
> I did a correct merge now, the hashs are the same in bluetooth-next:
> 
> 671267b Bluetooth: mgmt: Fix device_connected sending order
> a7d7723 Bluetooth: notify userspace of security level change
> 574e02a rtlwifi: fix for race condition when firmware is cached
> 
> and in wireless:
> 
> 671267b Bluetooth: mgmt: Fix device_connected sending order
> a7d7723 Bluetooth: notify userspace of security level change
> 574e02a rtlwifi: fix for race condition when firmware is cached
> 
> 	Gustavo
> 
> ---
> 
> The following changes since commit 341352d13dae752610342923c53ebe461624ee2c:
> 
>   iwlwifi: fix-up some merge damage from commit 0d6c4a2 (2012-05-08 22:18:09 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to 48af33a8ff98515915fb40021de91066f2a45d49:

I applied a last minute patch and then realized it was wrong. Just removed it,
the new head is: d839c81372d1f0caee47f87b26a68e91d4ff3847

	Gustavo
