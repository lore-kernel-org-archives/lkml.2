Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1BAWUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:20:19 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51270 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1BAWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:20:17 -0500
Subject: Re: [patch 3/3] mn10300: Use clockevents_calc_mult_shift()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
In-Reply-To: <20110131131809.017899070@linutronix.de>
References: <20110131131707.795836437@linutronix.de>
	 <20110131131809.017899070@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 14:20:10 -0800
Message-ID: <1296598810.3336.111.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 13:19 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (mn10300-use-clockevents_calc_mult_shift.patch)
> Use clockevents_calc_mult_shift() instead of the homebrewn function in
> mn10300/kernel/time.c.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Cc: Mark Salter <msalter@redhat.com> 

Acked-by: John Stultz <johnstul@us.ibm.com>


