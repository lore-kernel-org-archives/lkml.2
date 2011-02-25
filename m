Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1BYNbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:31:46 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35378 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1BYNbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:31:45 -0500
Message-ID: <4D67AEEE.30000@ru.mvista.com>
Date: Fri, 25 Feb 2011 16:30:22 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 6/7] arm/dt: Basic tegra devicetree support
References: <20110223021524.18318.71902.stgit@localhost6.localdomain6> <20110223022234.18318.90592.stgit@localhost6.localdomain6> <4D657880.50405@ru.mvista.com> <20110223213601.GA5404@angua.secretlab.ca>
In-Reply-To: <20110223213601.GA5404@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-02-2011 0:36, Grant Likely wrote:

>>> This patch adds adds very basic support for booting tegra with a
>>> device tree.  It simply allows the existing machine_descs to match
>>> against the tegra compatible values so that the kernel can boot.
>>> Kernel parameters and the initrd pointer is read out of the tree
>>> instead of atags.

>>> This is not complete device tree support.  This change will be
>>> reverted when a new machine_desc is added that can populate the
>>> device registrations directly from data in the tree instead of using
>>> hard coded data.  That change will be made in a future patch.

>>> v2: Fixed cut-and-paste error in commit text

>>     Shouldn't this sentence follow the --- tearline?

> Nope!  It is actually quite useful for the version information to show
> up in the commit text.  That way you know *exactly* which version got
> merged.  dwmw2 pointed that out to me a few months back.

    Well, I think that depends on the patch. If you have say 9 revisions with 
significant changes (that's what I actually had) and the revision history far 
exceeds the original patch description, then this will just become too ugly I 
think...

WBR, Sergei
