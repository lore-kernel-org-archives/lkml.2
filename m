Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2FKK56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:57:58 -0400
Received: from mail.pr.hu ([87.242.0.5]:59196 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab2FKK55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:57:57 -0400
Message-ID: <4FD5CF0A.7000905@pr.hu>
Date: Mon, 11 Jun 2012 12:57:14 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
References: <4FD4F45D.5050103@pr.hu> <4FD5A3A8.4020305@ladisch.de> <4FD5A89E.1000202@pr.hu> <4FD5C6C6.30000@ladisch.de>
In-Reply-To: <4FD5C6C6.30000@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.1 (--)
X-Scan-Signature: 3be2f66aaf20b59cd4b0edf337d6e8f4
X-Spam-Tracer: backend.mail.pr.hu -2.1 20120611105715Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-06-11 12:21 keltezéssel, Clemens Ladisch írta:
> All caches and your memory are ECC protected,
>> Unfortunately the memory is not with ECC.
> Sorry, I misread your mail.
>
> This means that you cannot rule out bad memory.

And there were two storms recently with lightings that struck nearby. :-(
I will retest with memtest86+.

Thanks for everyone who replied.

Best regards,
Zoltán Böszörményi

