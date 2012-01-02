Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2ABX0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 18:26:00 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54110 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001Ab2ABXZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 18:25:57 -0500
X-Sasl-enc: FIuQbs8CFTFCU2Jb7Rthzxwty5d3AVYlQS1jUmRwO8m1 1325546756
Message-ID: <4F023D02.1030403@fastmail.fm>
Date: Mon, 02 Jan 2012 23:25:54 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marek Vasut <marek.vasut@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <201201022252.20139.marek.vasut@gmail.com> <4F022846.8080305@fastmail.fm> <201201022331.27562.marek.vasut@gmail.com>
In-Reply-To: <201201022331.27562.marek.vasut@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/12 22:31, Marek Vasut wrote:
>> I don't think there is anyway to avoid the memory requirement if we want
>> to be able to resume transparently to user-space (or even resume at all
>> in some setups).
> 
> Well ... injecting firmware into kernel with some userland helper just before 
> suspend is no-go?

Its a perfectly good idea but you still need the full memory requirement
during the suspend.

Thanks,

Jack

