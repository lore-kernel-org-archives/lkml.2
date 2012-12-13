Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2LMUy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:54:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53460 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2LMUyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:54:54 -0500
MIME-Version: 1.0
In-Reply-To: <20121213204953.GA25085@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
 <20121213184820.GC12105@kroah.com> <20121213200857.GA24939@otc-wbsnb-06>
 <CAE9FiQUMSnCPwgbupZ5cFWLMiVxA4FQ2dNWNk+XYhvtEn+F3Ag@mail.gmail.com>
 <CA+55aFwxmhcgORCnDKwcp5EuzvC0iz02O4QR3H_stTXDbprYSA@mail.gmail.com> <20121213204953.GA25085@otc-wbsnb-06>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 12:54:33 -0800
X-Google-Sender-Auth: kSSCutL-orE01tPMTmRBjdGfx2g
Message-ID: <CA+55aFwpQA9xFOLxayO8sNtjaTug+uGTzXxuthxrbQZwOfvf0A@mail.gmail.com>
Subject: Re: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel
 DZ77RE-75K motherboard
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 12:49 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> PCI rescan is expensive and generate noise in dmesg. We'll end up with
> tons of useless messages.

So?

That's still better than adding random DMI string checks.

And christ, this is at hotplug time only. Nobody cares.

            Linus
