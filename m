Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1KUT2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:28:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab1KUT2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:28:44 -0500
Date: Mon, 21 Nov 2011 14:28:39 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: e1000 vlan functionality broken in 3.1
Message-ID: <20111121192839.GA2585@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a couple of reports of the e1000 driver no longer working with
tagged VLANs in the 3.1 kernel.  The bug report has much more detail
here:

https://bugzilla.redhat.com/show_bug.cgi?id=754589

The summary is, if you turn of rxvlan and tx offloading, the driver
seems to work fine with 3.1 again whereas this wasn't needed on 3.0.
(Fedora calls 3.0 2.6.40 on Fedora 15, but that is strictly a naming
thing.)

Looking through the commit logs, 5622e4044a91 seems to be the most
relevant commit between those versions.  Does anyone have any ideas?

josh
