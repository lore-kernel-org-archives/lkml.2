Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1EJL56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:57:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49155 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab1EJL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:57:57 -0400
Message-ID: <4DC927DF.1060808@ru.mvista.com>
Date: Tue, 10 May 2011 15:56:15 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: pause: no need to wait for FIFO
 empty
References: <be7d19459501aaa604aebe91daa9e9e59bb41c86.1304704588.git.nicolas.ferre@atmel.com> <1304957497-22814-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1304957497-22814-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-05-2011 20:11, Nicolas Ferre wrote:

> The addition of the pause feature to atc_control an active wait was introduced
> to check the FIFO empty event.

    Couldn't parse this -- did you forget "with"at the start of the statement?

> This event was not always happening and
> a timout contition was needed.
> But, in some cases, this event depend on the peripheral connected to the
> channel that is paused: FIFO becomes empty if the peripheral consumes data.
> The timeout is pretty difficult to evaluate. Moreover, this check is not
> needed.
> In conclusion, it seems sensible to entirely remove the checking of
> "FIFO empty" status when pausing.

> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>

WBR, Sergei
