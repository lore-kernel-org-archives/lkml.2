Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1GTUTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 16:19:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33873 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1GTUTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 16:19:37 -0400
MIME-Version: 1.0
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76383CF0DD2277@HQMAIL03.nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
 <CACxGe6uDVdemjbjY_i-_M_-VT8HuLdtXP-R9V8kB+pSSin4dEw@mail.gmail.com> <643E69AA4436674C8F39DCC2C05F76383CF0DD2277@HQMAIL03.nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 20 Jul 2011 14:19:16 -0600
X-Google-Sender-Auth: 7NxoGL9Mi-vMeF0i989wWZuUrbQ
Message-ID: <CACxGe6tEEr11vd3tqDwQ00YhUi7tMzovmS2PZGW9jt1K6VBefg@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
To: Andrew Chew <AChew@nvidia.com>
Cc: "olof@lixom.net" <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 2:16 PM, Andrew Chew <AChew@nvidia.com> wrote:
>> Can the driver use sane defaults for any of these values?  This patch
>> will be a lot smaller if there isn't the need to check all the return
>> values each time.
>
> The defaults are in the dt ehci node.  I'd really hate to duplicate these defaults in C code as well, if that's what you're suggesting (they're already duplicated privately elsewhere, sadly, in mach-tegra, but I'm hoping those defaults can go away once we move over to dt for good).  By failing probe if these defaults aren't present, I think it helps make sure the dt ehci node stays in sync with the code.

I'm saying that if the binding and the driver encode sane defaults for
those parameters, then the properties don't need to appear in the .dts
at all unless they are being overridden.  It is by no means a critical
issue though.  Do what makes the most sense to you.

g.
