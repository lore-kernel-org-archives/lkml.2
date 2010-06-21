Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0FUW1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:27:36 -0400
Received: from eazy.amigager.de ([213.239.192.238]:46702 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab0FUW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:27:35 -0400
Date: Tue, 22 Jun 2010 00:27:38 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Suspend hangs since 2.6.34
Message-ID: <20100621222738.GA7166@mac.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <20100609175356.GA17332@x61.home>
 <201006100142.13131.rjw@sisk.pl>
 <20100620225601.GA15589@x61.home>
 <201006212124.09076.rjw@sisk.pl>
 <20100621213224.GA5723@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621213224.GA5723@mac.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

another observation:

As the the computer suspends if I kill the hanging suspend script, I
tried to see that the suspend script is doing. So I attached strace to
it:

$ strace -f -p 6652

After this, the computer suspended.

Regards,
Tino
