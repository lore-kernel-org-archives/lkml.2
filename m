Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0JEWua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:50:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48752 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab0JEWu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:50:29 -0400
Message-ID: <4CABAB9A.4060007@zytor.com>
Date: Tue, 05 Oct 2010 15:50:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor
 early reserved ranges
References: <4CAA4BD5.4020505@kernel.org> <4CAA4DF9.9060205@kernel.org>
In-Reply-To: <4CAA4DF9.9060205@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 02:58 PM, Yinghai Lu wrote:
>  
> +int __init get_free_all_memory_range(struct range **rangep, int nodeid)
> +{
> +	unsigned long end_pfn = -1ULL;
> +

Uh... I really hope I don't have to explain what's wrong with that...

	-hpa
