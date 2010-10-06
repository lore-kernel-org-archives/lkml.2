Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab0JFXAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:00:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760045Ab0JFXAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:00:21 -0400
Message-ID: <4CACFF66.5080609@zytor.com>
Date: Wed, 06 Oct 2010 15:59:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CACFDAD.3090900@goop.org> <4CACFECD.3090304@kernel.org>
In-Reply-To: <4CACFECD.3090304@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 03:57 PM, Yinghai Lu wrote:
> 
> How about
> +	if (memblock.memory.regions)
> +		return;	
> 

I was just about to ask the same question. ;)

	-hpa
