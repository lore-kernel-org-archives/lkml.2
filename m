Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2GJPVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:21:19 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:41576 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2GJPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:21:18 -0400
Message-ID: <4FFC4868.4030400@xs4all.nl>
Date: Tue, 10 Jul 2012 17:21:12 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.4.4 r8169 weirdness
References: <4FFB13E6.40904@xs4all.nl> <20120709202828.GA20338@electric-eye.fr.zoreil.com>
In-Reply-To: <20120709202828.GA20338@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-09 22:28, Francois Romieu wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> :
> [...]
>> Is my hardware dying or is it the kernel?
> 
> Try adding eb2dc35d99028b698cdedba4f5522bc43e576bd2 if you own a 8168evl.
> 
> If you don't, try reverting 036dafa28da1e2565a8529de2ae663c37b7a0060.

Reverting 036dafa28da1e2565a8529de2ae663c37b7a0060 appears to have a
positive effect but it needs more time (few hours) to be sure.

Thanks,
Udo



