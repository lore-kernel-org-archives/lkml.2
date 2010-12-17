Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0LQDA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:00:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0LQDAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:00:25 -0500
Message-ID: <4D0AD232.8020107@zytor.com>
Date: Thu, 16 Dec 2010 19:00:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 0/9] PCI: revert to allocating bottom-up, avoid E820 areas
References: <20101216173614.8185.19462.stgit@bob.kio> <AANLkTikqmfWhLuTiP8tPqcCGMZUe=iDOJVUZGy8pnRL0@mail.gmail.com>
In-Reply-To: <AANLkTikqmfWhLuTiP8tPqcCGMZUe=iDOJVUZGy8pnRL0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 01:59 PM, Linus Torvalds wrote:
> On Thu, Dec 16, 2010 at 9:38 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>
>> So I think the best band-aid for now is to revert to bottom-up allocation
>> and do a better job of avoiding E820 reserved areas.  Obviously, it's not
>> complete because we could still trip over ACPI devices (as in 23802), but
>> that's a problem we've always had and it's not as likely if we go bottom-up.
> 
> Ok, ack for this series. Have we got testers for it? In particular,
> have the people who have seen regressions been notified of this new
> series?
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

... for the series as well.  For what it's worth.

	-hpa
