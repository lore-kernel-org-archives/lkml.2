Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1JHRSC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 13:18:02 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6046 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1JHRSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 13:18:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bmEboQ3DlMupT8Bg/ZdwpKR4juhAeL3Uq3Hi9n5TUn1F367i4SAegb7pShQtaJe6z
	opbM9/Djbl2iPHiI6zFPg==
MIME-Version: 1.0
In-Reply-To: <CAHFNz9L-WDeEGx9MazTawJF-Hsz88FS7Z=RinfrKn780jBf++A@mail.gmail.com>
References: <CAHFNz9L-WDeEGx9MazTawJF-Hsz88FS7Z=RinfrKn780jBf++A@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 8 Oct 2011 11:17:38 -0600
Message-ID: <CAErSpo6CH-FHOughZu3KSsRYHX2dvncB1sFBNVp+ivEHNs52yA@mail.gmail.com>
Subject: Re: Memory at xxxxxx [disabled]
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 9:51 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi,
>
> Any Idea why I am seeing the [disabled] for the specified memory
> region as described below ?
>
> 04:07.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
> Device [1822:4e31] (rev 01)
>        Subsystem: Twinhan Technology Co. Ltd Device [1822:0010]
>        Flags: medium devsel, IRQ 11
>        Memory at fd900000 (32-bit, prefetchable) [disabled] [size=4K]

The complete dmesg log should have some clues.  Normally we use the
resources assignments done by BIOS.

Bjorn
