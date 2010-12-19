Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab0LSOb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 09:31:56 -0500
Received: from smtpauth.net4india.com ([118.67.248.47]:50048 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0LSObz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 09:31:55 -0500
Message-ID: <4D0E1727.3040307@xenontk.org>
Date: Sun, 19 Dec 2010 20:01:03 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.2.13) Gecko/20101209 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 0/9] PCI: revert to allocating bottom-up, avoid E820 areas
References: <20101216173614.8185.19462.stgit@bob.kio> <AANLkTikqmfWhLuTiP8tPqcCGMZUe=iDOJVUZGy8pnRL0@mail.gmail.com> <201012170900.56415.bjorn.helgaas@hp.com>
In-Reply-To: <201012170900.56415.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 12/17/2010 09:30 PM, Bjorn Helgaas wrote:
>     https://bugzilla.kernel.org/show_bug.cgi?id=23132 (Dell 1545)

I can confirm that the latest PCI pull fixes this bug.

Regards,
David.
