Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1BAWT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:19:27 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:60635 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1BAWT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:19:26 -0500
Subject: Re: [patch 2/3] mn10300: Use clocksource_register_hz()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
In-Reply-To: <20110131131808.916682507@linutronix.de>
References: <20110131131707.795836437@linutronix.de>
	 <20110131131808.916682507@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 14:19:18 -0800
Message-ID: <1296598758.3336.110.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 13:19 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (mn10300-use-clocksource-register-hz.patch)
> clocksource_register_hz() calculates the shift/mult pair for the
> clocksource. Remove the mn10300 duplicate implementation.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Cc: Mark Salter <msalter@redhat.com>

Acked-by: John Stultz <johnstul@us.ibm.com>


