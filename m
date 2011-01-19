Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1ASKGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:06:17 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54767 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab1ASKGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:06:15 -0500
Message-ID: <4D36B76D.4030609@stericsson.com>
Date: Wed, 19 Jan 2011 11:05:33 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the rr tree
References: <20110119154210.435453e4.sfr@canb.auug.org.au> <201101192029.57595.rusty@rustcorp.com.au>
In-Reply-To: <201101192029.57595.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 10:59 AM, Rusty Russell wrote:
> module: fix missing semicolons in MODULE macro usage

Man, you're too fast for me :-) Thanks for fixing the two violators.

Yours,
Linus Walleij
