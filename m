Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069Ab2ILSbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:31:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60354 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760812Ab2ILSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:31:16 -0400
Date: Wed, 12 Sep 2012 21:31:06 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-09-08
Message-ID: <20120912183106.GA10402@x220.P-661HNU-F1>
Mail-Followup-To: "John W. Linville" <linville@tuxdriver.com>,
	Gustavo Padovan <gustavo@padovan.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120908215956.GP5788@joana>
 <20120912181309.GB28823@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912181309.GB28823@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Wed, Sep 12, 2012, John W. Linville wrote:
> "Bluetooth: mgmt: Implement support for passkey notification" doesn't
> look like a fix at all.

This fixes pairing with keyboards that have a "KeyboardOnly" IO
capability. This used to work previously in a world where user space
spoke HCI directly to the Bluetooth controller but is broken with any
user space version using the recently introduced management interface.

> "Bluetooth: Update management interface revision" is suspect.  It kinda
> makes sense, but if it is so important than it should have been merged
> much earlier, no?

This patch is due to the first one. We increment the revision every time
something gets added to the management interface. FWIW, I've tested that
pairing now works with keyboards of this kind with these patches.

Johan
