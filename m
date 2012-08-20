Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2HTV2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:28:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59783 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2HTV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:28:00 -0400
Date: Mon, 20 Aug 2012 23:27:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Build usb_speed_string unconditionally
Message-ID: <20120820212759.GH16230@one.firstfloor.org>
References: <20120820195808.GD4461@tassilo.jf.intel.com> <Pine.LNX.4.44L0.1208201639050.1182-100000@iolanthe.rowland.org> <20120820204944.GA19667@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820204944.GA19667@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi, care to try this again with this .config on Linus's tree to see if
> it all now works properly?

Works in mainline. Thanks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
