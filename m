Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1LJW6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 17:58:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58088 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1LJW6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 17:58:38 -0500
Message-ID: <4EE3E41A.8090708@gmail.com>
Date: Sat, 10 Dec 2011 15:58:34 -0700
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
References: <4EE2BC33.80902@gmail.com> <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
In-Reply-To: <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2011 01:17 PM, Yinghai Lu wrote:
> your bios should not enable x2apic in this case.

I am, in fact, able to disable x2apic in the BIOS and it works fine.  I
was just under the impression that x2apic should be available and should
work?  Is this wrong?  If so, then there's no kernel bug, and I just
misunderstood.
