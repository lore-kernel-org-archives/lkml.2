Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab2CGNr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:47:28 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:52718 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab2CGNr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:47:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20311.26346.228434.659284@quad.stoffel.home>
Date: Wed, 7 Mar 2012 08:47:22 -0500
From: "John Stoffel" <john@stoffel.org>
To: David Miller <davem@davemloft.net>
Cc: john@stoffel.org, linux-kernel@vger.kernel.org
Subject: Re: Why does NET_VENDOR_DEC default to y?
In-Reply-To: <20120306.234734.1508316807241059857.davem@davemloft.net>
References: <20310.57932.964124.347872@quad.stoffel.home>
	<20120306.234734.1508316807241059857.davem@davemloft.net>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David> The new "vendor" Kconfig guards default to 'y', not the drivers
David> themselves.

Thanks for the info.  I see that not all of the new vendor Kconfig
default to y, so I was just surprised by the change and it not being
consistent.  And looking more carefully at my old config, I see that I
did have DEC Tulip cards listed as M, so it's all my fault.

Sorry for the noise.
John
