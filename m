Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1LJXLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 18:11:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62373 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1LJXLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 18:11:52 -0500
MIME-Version: 1.0
In-Reply-To: <4EE3E41A.8090708@gmail.com>
References: <4EE2BC33.80902@gmail.com>
	<CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
	<4EE3E41A.8090708@gmail.com>
Date: Sat, 10 Dec 2011 15:11:51 -0800
X-Google-Sender-Auth: Yos2-QuAkwVvTiy8uxBqni2qI7s
Message-ID: <CAE9FiQXc6k+5gvknFHwWNHGPSN_Gw2CUzaJJWoSdn6Oz5t4dZQ@mail.gmail.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Yinghai Lu <yinghai@kernel.org>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 2:58 PM, Berck E. Nash <flyboy@gmail.com> wrote:
> On 12/10/2011 01:17 PM, Yinghai Lu wrote:
>> your bios should not enable x2apic in this case.
>
> I am, in fact, able to disable x2apic in the BIOS and it works fine.  I
> was just under the impression that x2apic should be available and should
> work?  Is this wrong?  If so, then there's no kernel bug, and I just
> misunderstood.

it's not kernel bug.

BIOS need to provide DMAR table, so kernel could enable
intr-rempapping, and x2apic need intr-remap.

Thanks

Yinghai
