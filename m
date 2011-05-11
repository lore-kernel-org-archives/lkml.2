Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1EKCyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 22:54:25 -0400
Received: from imr4.ericy.com ([198.24.6.8]:56237 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1EKCyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 22:54:24 -0400
Date: Tue, 10 May 2011 19:53:38 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Nat Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
Subject: Re: [PATCH v10 2/2] Use "request_muxed_region" in it87 hwmon
 drivers
Message-ID: <20110511025338.GB4051@ericsson.com>
References: <1304966644-19798-1-git-send-email-natg@google.com>
 <1304966731-19896-1-git-send-email-natg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1304966731-19896-1-git-send-email-natg@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 02:45:31PM -0400, Nat Gurumoorthy wrote:
> 02 - Chages to hwmon it87 driver to use "request_muxed_region"
> Serialize access to the hardware by using "request_muxed_region" macro defined
> by Alan Cox. Call to this macro will hold off the requestor if the resource is
> currently busy. "superio_enter" will return an error if call to 
> "request_muxed_region" fails. Rest of the code change is to ripple an error
> return from superio_enter to the top level.
> 
> Signed-off-by: Nat Gurumoorthy <natg@google.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

