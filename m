Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2G0OMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:12:34 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:37906 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2G0OMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:12:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20498.41365.853741.261834@quad.stoffel.home>
Date: Fri, 27 Jul 2012 10:11:33 -0400
From: "John Stoffel" <john@stoffel.org>
To: <sandeep@freescale.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-arm-kernel@lists.infradead.org>,
        <galak@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
Subject: Re: [2/3][PATCH][v2] TDM Framework
In-Reply-To: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Sandeep Singh <Sandeep@freescale.com>
> TDM Framework is an attempt to provide a platform independent layer which can
> offer a standard interface  for TDM access to different client modules.

Please don't use TLAs (Three Letter Acronyms) like TDM without
explaining the clearly and up front.  It makes it hard for anyone else
who doens't know your code to look it over without having to spend
lots of time poking around to figure it out from either context or
somewhere else.

John
