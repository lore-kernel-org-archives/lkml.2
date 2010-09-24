Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab0IXX7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:59:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53121 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0IXX7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Nk2j8L0KjKQlAZWlwHyMjKZCgF4O3ONHbzU00HEVmk9Oz7t6szt2nMB2HHP1dsUPCa
         ZQLayR9GIF8sw6r/wM7Ai+W9VI79eKbZiLHR7vCg7deLtKTQEXhye6o5G3vFBdzGpggg
         hIbEPrxZUwPfmx8Z3eFT/j8uUByabme7dEN5A=
MIME-Version: 1.0
In-Reply-To: <201009241706.11742.bjorn.helgaas@hp.com>
References: <20100923233047.12463.61480.stgit@bob.kio>
	<201009241706.11742.bjorn.helgaas@hp.com>
Date: Fri, 24 Sep 2010 16:59:05 -0700
X-Google-Sender-Auth: Gvp4I7icqAP0-mx52neT5_bEIdU
Message-ID: <AANLkTi=GrH4fR_wSFytaSiXsH+wo2a=DaLAU4H2d0d1M@mail.gmail.com>
Subject: Re: [PATCH] x86, HPET: mark HPET PCI BARs as IORESOURCE_PCI_FIXED
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Prarit Bhargava <prarit@redhat.com>, fredlwm@gmail.com,
        Simon Arlott <simon@fire.lp0.eu>, x86@kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 4:06 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> Sorry Yinghai, I forgot to copy you on the initial post.  Any
> comments on this?  If not, we should try to get it into linux-next
> soon.

should be good.

only one thing, that will punish all other vendors... and run that
quirk for every pci device.

please check if you can have
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID, mark_pci_hpet_fixed);

AND _AMD maybe, if AMD dump _ATI brand later.

Thanks

Yinghai
