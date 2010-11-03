Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab0KCFNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 01:13:17 -0400
Received: from claw.goop.org ([74.207.240.146]:48217 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab0KCFNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:13:16 -0400
Message-ID: <4CD0EF61.2040007@goop.org>
Date: Wed, 03 Nov 2010 01:13:05 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Debug patches for memblock
References: <4CAA4DC1.6000104@kernel.org> <4CACFDAD.3090900@goop.org> <4CACFECD.3090304@kernel.org> <4CACFF66.5080609@zytor.com> <4CAE121E.4080607@goop.org> <4CD0EDB3.8030901@kernel.org>
In-Reply-To: <4CD0EDB3.8030901@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 01:05 AM, Yinghai Lu wrote:
> Jeremy,
>
> Please check some debug patches for memblock in
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock
>
> hope you can use them to find out causes for some xen failure.

Thanks, I'll take a look.

    J
