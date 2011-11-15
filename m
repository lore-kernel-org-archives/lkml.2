Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1KOP6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:58:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58969 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab1KOP6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:58:12 -0500
MIME-Version: 1.0
In-Reply-To: <20111114.214542.1423779515286773837.davem@davemloft.net>
References: <CANEJEGuzdxDuVysuAJPcdC7-mywa8B8JggVHe_VMTK_1j4QguQ@mail.gmail.com>
	<20111114.213255.2061756136146824209.davem@davemloft.net>
	<20111114.214151.1988775203701808195.davem@davemloft.net>
	<20111114.214542.1423779515286773837.davem@davemloft.net>
Date: Tue, 15 Nov 2011 07:58:11 -0800
X-Google-Sender-Auth: UVq6H6HJPW_EQD3wGMJqS8M0fD0
Message-ID: <CANEJEGtj4ZMd2ewrMjYLjor2216UGWBhfywDEtAP0Z_+cMGqmQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] net-next:asix: update VERSION and white space changes
From: Grant Grundler <grundler@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw, kernel@teksavvy.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 6:45 PM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 14 Nov 2011 21:41:51 -0500 (EST)
>
>> Come on man... are you kidding me?

Dave,
my apologies. That's obviously my fail.

The problem is I can't test your git tree on my systems...but I should
have at least compile tested it. Or just submitted the changes
straight from chromium.org tree. *sigh*

> Want to know what really pisses me off about this?
>
> All of Mark Lord's hard work to bring the entire vendor driver over
> was thrown out.

Not entirely correct as Mark pointed out. I was able to convince ASIX
they should be working with Mark and they committed to doing so.

> And it was thrown out in favor of this!  Code that doesn't even
> compile.

*sigh* sorry...I'll resubmit the entire mess and compile test first. /o\

thanks for your patience,
grant
