Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab1LLPGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:06:01 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48755 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062Ab1LLPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:06:00 -0500
X-Sasl-enc: OyjcZbrQ+QS5tehcqjd4BVSyBwHbsjgfmZqUTjB19GHc 1323702359
Date: Mon, 12 Dec 2011 07:02:55 -0800
From: Greg KH <greg@kroah.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kref: add function for reading kref value
Message-ID: <20111212150255.GA7506@kroah.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 02:44:52PM +0200, Daniel Baluta wrote:
> We can easily get kref refcount value by accesing
> kref->refcount but it is better to have a function
> for this.

No, you should NEVER need the value of the kref, if you do, you are
doing something wrong.

What code needs this patch?

greg k-h
