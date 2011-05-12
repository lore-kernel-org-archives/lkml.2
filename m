Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1ELMCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:02:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1385 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1ELMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:02:18 -0400
Date: Thu, 12 May 2011 14:01:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Nat Gurumoorthy <natg@google.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, mikew@google.com
Subject: Re: [PATCH v10 2/2] Use "request_muxed_region" in it87 hwmon
 drivers
Message-ID: <20110512140124.004a5921@endymion.delvare>
In-Reply-To: <1304966731-19896-1-git-send-email-natg@google.com>
References: <1304966644-19798-1-git-send-email-natg@google.com>
	<1304966731-19896-1-git-send-email-natg@google.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 May 2011 11:45:31 -0700, Nat Gurumoorthy wrote:
> 02 - Chages to hwmon it87 driver to use "request_muxed_region"
> Serialize access to the hardware by using "request_muxed_region" macro defined
> by Alan Cox. Call to this macro will hold off the requestor if the resource is
> currently busy. "superio_enter" will return an error if call to 
> "request_muxed_region" fails. Rest of the code change is to ripple an error
> return from superio_enter to the top level.
> 
> Signed-off-by: Nat Gurumoorthy <natg@google.com>
> ---
> (...)

Patch applied, thanks.

-- 
Jean Delvare
