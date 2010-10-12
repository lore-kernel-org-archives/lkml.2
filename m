Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab0JLWDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:03:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45385 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0JLWDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:03:45 -0400
Message-ID: <4CB4DB00.3080904@kernel.org>
Date: Tue, 12 Oct 2010 15:02:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4D62C.5090705@goop.org> <4CB4D809.5050500@zytor.com>
In-Reply-To: <4CB4D809.5050500@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 02:50 PM, H. Peter Anvin wrote:
> On 10/12/2010 02:42 PM, Jeremy Fitzhardinge wrote:
>>>
>>> two xen related patch are folded into first converting commit.
>>
> 
> Yinghai, is this the same bug as the ARM bug (which is assumed fixed by
> the patch you sent me), or is this a different bug?

should be different.

other memblock users still try to converting memblock to bootmem, so they need _pfn functions...

Yinghai
