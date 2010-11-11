Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0KKTa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:30:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644Ab0KKTaz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:30:55 -0500
MIME-Version: 1.0
In-Reply-To: <20101111104836.0368d858@jbarnes-desktop>
References: <20101110172607.2537.10985.stgit@bob.kio> <20101111104836.0368d858@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Nov 2010 11:24:42 -0800
Message-ID: <AANLkTi=u3u1GbVgoedx5h-Fqp8XqLJ47Hme3oyDw5e4y@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: fix pci_bus_alloc_resource() hang, prefer
 positive decode
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Bob Picco <bpicco@redhat.com>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@amd64.org>, Stefan Becker <chemobejk@gmail.com>,
        Chuck Ebbert <cebbert@redhat.com>,
        Fabrice Bellet <fabrice@bellet.info>, Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:48 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> How does this one look, Linus?  If you're ok with this version I'll
> include it in my next pull request.

Sure, I'm ok with it.

          Linus
