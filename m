Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0JOHSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:18:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64570 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0JOHSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q1RJi7ADJw826qABIdg+oFe+Tfhzp5sXdbANkw2/JH9NxLJLLASGRE0+Qb+pOVlZcF
         T/auj4XJyjn7K8qfzEpY6CPT2uPOFf0CqzW6mp842m+qD03FGfOF1eIRRvT1lt9KdEKo
         AQQyWKn5iqv8V0/IeGa8maeC1rzYzM2JHWglk=
MIME-Version: 1.0
In-Reply-To: <20101015064152.GA438@elte.hu>
References: <20101010094032.9AE669D401B@zog.reactivated.net>
	<tip-bf1ebf007911d70a89de9a4a1b36d403e8eb064b@git.kernel.org>
	<20101015064152.GA438@elte.hu>
Date: Fri, 15 Oct 2010 08:18:50 +0100
X-Google-Sender-Auth: ZM0akDmDOxx5umHpd1mTPWIweFc
Message-ID: <AANLkTimBBSB7-9-p7jDBQrx6kUMnT2c0QDzVCEJX8C7u@mail.gmail.com>
Subject: Re: [tip:x86/olpc] x86, olpc: Add XO-1 poweroff support
From: Daniel Drake <dsd@laptop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2010 07:41, Ingo Molnar <mingo@elte.hu> wrote:
> FYI, this commit introduced a new build failure on =m and CONFIG_PCI
> off:
>
> arch/x86/kernel/olpc-xo1.c:65: error: implicit declaration of function ‘pci_enable_device_io’
> arch/x86/kernel/olpc-xo1.c:71: error: implicit declaration of function ‘pci_request_region’
> arch/x86/kernel/olpc-xo1.c:80: error: implicit declaration of function ‘pci_release_region’

Sorry about that.
Randy Dunlap already sent a patch titled "[PATCH -next] x86: olpc-xo1
uses/depends on PCI"

Any chance you can just pull that one into the tree? Or shall I
resubmit to x86 maintainers specifically?

Thanks,
Daniel
