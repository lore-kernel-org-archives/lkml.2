Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1F1Vzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:55:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34609 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1F1VzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:55:25 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.136.221]
In-Reply-To: <20110627232903.GB7736@n2100.arm.linux.org.uk>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-2-git-send-email-ohad@wizery.com> <20110627204958.GB20865@ponder.secretlab.ca>
 <20110627232903.GB7736@n2100.arm.linux.org.uk>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Jun 2011 00:55:04 +0300
Message-ID: <BANLkTinG=uiUwq4oKGPCX4Phi7gM8NwSQg@mail.gmail.com>
Subject: Re: [RFC 1/8] drivers: add generic remoteproc framework
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 2:29 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> (Don't have the original message to reply to...)

Sorry about that.

My recent emails to linux-arm-kernel were bounced with a "Message has
a suspicious header" reason. not sure what am I doing wrong..

> Do we really want to end up with header being 5 bytes, header_len set
> as 5, and having to load/store all this data using byte loads/stores ?

As Grant said, we're trying to move to ELF now, but if we do end up
sticking with this custom format eventually, we'll sure do take care
of all the alignment issues.

Thanks!
