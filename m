Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1ADOK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:10:56 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63843 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1ADOKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:10:55 -0500
Message-ID: <4D232A6A.1030307@criticallink.com>
Date: Tue, 04 Jan 2011 09:10:50 -0500
From: Michael Williamson <michael.williamson@criticallink.com>
Organization: Critical Link, LLC
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, khilman@deeprootsystems.com,
        linux-serial@vger.kernel.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: Provide capability to disable modem status
 interrupts in 8250 driver
References: <1294149062-31173-1-git-send-email-michael.williamson@criticallink.com> <20110104135621.56a4770e@lxorguk.ukuu.org.uk>
In-Reply-To: <20110104135621.56a4770e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/2011 8:56 AM, Alan Cox wrote:

>> This patch was tested using a MityDSP-L138F platform having a UART CTS pin
>> connected to a clock signal (and configured, via pinmux, as a clock input
>> for another peripheral function).
> 
> Please hide such horrors in your platform code. We are trying todrive all
> the quirks stuff we can out of the core code.
> 
> Instead provide your own I/O methods when registering the port and mask
> the appropriate bogus bits in the register.
> 


Got it.  Thanks for the guidance.

-Mike

