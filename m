Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2HYSag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 14:30:36 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:46723 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2HYSae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 14:30:34 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuNUAG8ZOVBV5qoUPGdsb2JhbABFhRojhQCwLRkBAQEBHhkNJ4IgAQEEATocIwULCANGFCUKGogaCrtUFJElYAOVVIVsjQ8
X-IronPort-AV: E=Sophos;i="4.77,826,1336341600"; 
   d="scan'208";a="396841000"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 25 Aug 2012 20:35:43 +0200
To: Shea Levy <shea@shealevy.com>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
Message-ID: <20120825183543.GA4517@polaris.bitmath.org>
References: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
 <50390B54.4040706@shealevy.com>
 <20120825174342.GA4057@polaris.bitmath.org>
 <5039179D.6010909@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5039179D.6010909@shealevy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm getting a build error due to lack of
> USB_VENDOR_AND_INTERFACE_INFO macro when patching 3.5.2 with that
> patch. Which kernel tree should I patch with this patch to test?

The macro is in the pipe to 3.5.x, probably only a couple of days
away. The patch is for 3.6, as stated, meaning it applies on top of
Linus's tree.

Henrik
