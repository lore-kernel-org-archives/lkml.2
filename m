Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1KAQPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:15:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55078 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1KAQPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:15:15 -0400
Date: Tue, 1 Nov 2011 14:15:49 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: "Cho, Yu-Chen" <acho@suse.com>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, acho@novell.com, jlee@novell.com,
        oneukum@suse.com, jlee@suse.com
Subject: Re: [PATCH 1/3] add device entry for Broadcom Valentine combo card
Message-ID: <20111101161549.GG2580@joana>
Mail-Followup-To: "Cho, Yu-Chen" <acho@suse.com>, marcel@holtmann.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	acho@novell.com, jlee@novell.com, oneukum@suse.com, jlee@suse.com
References: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu-Chen,

* Cho, Yu-Chen <acho@suse.com> [2011-11-01 17:33:05 +0800]:

> This device declares itself to be vendor specific
> It therefore needs to be added to the device table
> to make btusb bind.
> 
> Signed-off-by: Cho, Yu-Chen <acho@suse.com>
> ---
>  drivers/bluetooth/btusb.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Ok, but where is the output of usb-devices that I asked. Thanks.

	 Gustavo
