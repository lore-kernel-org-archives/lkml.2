Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1BUUYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:24:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38986 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1BUUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:24:12 -0500
Date: Mon, 21 Feb 2011 20:24:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org,
        linux acpi <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luming Yu <luming.yu@intel.com>
Subject: Re: Should asus-wmi provide a way to switch displays, and why
	video_output class is unused
Message-ID: <20110221202402.GA22622@srcf.ucam.org>
References: <AANLkTimf3SL+BpzjVK=F9y4_dGnDp6ghmMKq5k=4hs0x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimf3SL+BpzjVK=F9y4_dGnDp6ghmMKq5k=4hs0x@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thought I'd replied to this already, but: Unless it's impossible for X 
and the kernel to handle enabling a display without this, don't bother. 
There's no reason for us to care about the combinations of outputs the
BIOS wants to support.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
