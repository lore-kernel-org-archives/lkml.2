Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1FILlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:41:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48713 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1FILlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UK8SlP1do31ksgO26HgBl944UQq0ScpjZqmX9wH0WF4/W+fJRDzgEz8Imc4hQZKwHs
         AA2YKPvio405x/ip1A9T3Hykq9LaHZ9Wkau9fS6Y8/yJkPeftzKq2RhtJreJUxqmKCKr
         iJiGHL8ogni0BfkSJTUPUapFD07A68IoNSyyE=
MIME-Version: 1.0
In-Reply-To: <4DF0A8B3.8090900@mev.co.uk>
References: <20110609092401.GA2777@mail.fossee.in> <4DF0A8B3.8090900@mev.co.uk>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Thu, 9 Jun 2011 17:10:55 +0530
Message-ID: <BANLkTim-bgWFVnp1Q9QqU2t5=-v7jg6jCw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: comedi: add dyna_pci10xx driver
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Thu, Jun 9, 2011 at 4:34 PM, Ian Abbott <abbotti@mev.co.uk> wrote:
> On 09/06/11 10:24, Prashant P. Shah wrote:

> It looks mostly okay to me as long as you got the PCI device ID
> allocated by PLX (which they'll happily do for their customers if you
> tell them what product the chip is is part of), and didn't just pull it
> out of a hat!

I will forward that to the vendor...

> I have a few more specific comments on the code (not many!):
> Best regards,
> Ian.

fixed and sent patch for the same.

Regards.
