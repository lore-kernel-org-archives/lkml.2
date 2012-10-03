Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2JCMxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:53:21 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:43901 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab2JCMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:53:20 -0400
Message-ID: <506C3532.4020400@synopsys.com>
Date: Wed, 3 Oct 2012 16:53:06 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.serial
To: Alan Cox <alan@linux.intel.com>
CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v3] serial/8250/8250_early: Prevent rounding error in
 uartclk
References: <1349267263-21683-1-git-send-email-abrodkin@synopsys.com> <20121003133740.69c9dbce@bob.linux.org.uk>
In-Reply-To: <20121003133740.69c9dbce@bob.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.10.2012 16:37, Alan Cox wrote:
>> So the bug had been latent and it only showed up with such low cock
>> rates.
>
> clock ?
>
> Perhaps Greg can tweak the description as it goes in - otherwise all
> fine with me
>
Sorry for this.
Essentially I meant "clock".
May do another respin if needed.
