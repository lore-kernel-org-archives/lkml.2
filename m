Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934180Ab1JaTRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:17:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37551 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1JaTRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:17:33 -0400
Date: Mon, 31 Oct 2011 17:18:09 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: "Cho, Yu-Chen" <acho@suse.com>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, acho@novell.com, jlee@novell.com,
        oneukum@suse.com
Subject: Re: [PATCH 1/2] add device entry for Broadcom Valentine combo card
Message-ID: <20111031191809.GB10164@joana>
Mail-Followup-To: "Cho, Yu-Chen" <acho@suse.com>, marcel@holtmann.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	acho@novell.com, jlee@novell.com, oneukum@suse.com
References: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu-Chen,

* Cho, Yu-Chen <acho@suse.com> [2011-10-20 12:58:29 +0800]:

> This device declares itself to be vendor specific
> It therefore needs to be added to the device table
> to make btusb bind.

It would be good to have the output of usb-devices for this specific device in
the commit message.

	Gustavo
