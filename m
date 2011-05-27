Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1E0ROg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:14:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43456 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1E0ROe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:14:34 -0400
Message-ID: <4DDFDBE7.6030702@zytor.com>
Date: Fri, 27 May 2011 10:14:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, asm: Clean up desc.h a bit
References: <tip-incpt6y26yd8586idx65t9ll@git.kernel.org> <4DDFD958.9090700@zytor.com> <20110527171240.GD4356@elte.hu>
In-Reply-To: <20110527171240.GD4356@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 10:12 AM, Ingo Molnar wrote:
> 
> Yeah. I really didnt want to modify functionality in this patch, just 
> wanted my eyes to not bleed. Using macros there would probably 
> generate better code as well, right?
> 

Probably.

	-hpa
