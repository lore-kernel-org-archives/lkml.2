Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0GJVSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:18:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57525 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0GJVSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:18:49 -0400
Message-ID: <4C38E3B1.3090401@cs.helsinki.fi>
Date: Sun, 11 Jul 2010 00:18:41 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC/PATCH] x86: Early-boot serial I/O support
References: <1278785277-22629-1-git-send-email-penberg@cs.helsinki.fi> <4C38C148.2060805@zytor.com>
In-Reply-To: <4C38C148.2060805@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>> +
>> +    while ((inb(early_serial_base + LSR)&  XMTRDY) == 0&&  --timeout)
>> +        ;
>> +
> 
> cpu_relax(); here, probably.

Fixed.
