Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab0HBS2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:28:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52174 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab0HBS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:28:17 -0400
Message-ID: <4C570DFE.503@zytor.com>
Date: Mon, 02 Aug 2010 11:27:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
References: <4C56701B.1030000@kernel.org> <AANLkTi=r-vt=Pr+xchiR+s12RDU9xQbXnmCB4pTJcc2_@mail.gmail.com>
In-Reply-To: <AANLkTi=r-vt=Pr+xchiR+s12RDU9xQbXnmCB4pTJcc2_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 10:56 AM, Thiago Farina wrote:
> 
> These to functions above can be fairly simplified by writting as:
> 
> static bool inline is_hex_digit(int c) {
>   return (c >= '0' && c <= '9') ||
>             (c >= 'A' && c <= 'F') ||
>             (c >= 'a' && c <= 'f');
> }
> 

a) You lose the isdigit() functionality, which is useful on its own.
b) Does this enahance readability in any way?
c) Your proposed renaming is nonstandard.

As such, I don't think this is a good idea.

	-hpa
