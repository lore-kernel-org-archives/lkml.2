Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab0FIWxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:53:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58728 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab0FIWxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:53:35 -0400
Message-ID: <4C101B58.2090208@zytor.com>
Date: Wed, 09 Jun 2010 15:53:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86, AMD: Extend support to future families
References: <20100602182921.GA21557@aftab>
In-Reply-To: <20100602182921.GA21557@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 11:29 AM, Borislav Petkov wrote:
> Extend support to future families, and in particular:
> 
> * extend direct mapping split of Tseg SMM area.
> * extend K8 flavored alternatives (NOPS).
> * rep movs* prefix is fast in ucode.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

This doesn't reflect any currently shipping hardware, right?

	-hpa
