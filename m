Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2ADSd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:33:58 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50705 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab2ADSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:33:56 -0500
Message-ID: <1325702014.3037.98.camel@work-vm>
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598  1.478005]
 IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
From: John Stultz <john.stultz@linaro.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Stefan Bader <stefan.bader@canonical.com>, NeilBrown <neilb@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jan 2012 10:33:34 -0800
In-Reply-To: <18544246.20120104141703@eikelenboom.it>
References: <1599287628.20120103171351@eikelenboom.it>
	 <20120103190754.GA27651@phenom.dumpdata.com>
	 <1325632188.3037.59.camel@work-vm> <20120104113155.27bf6e46@notabene.brown>
	 <1325638380.3037.69.camel@work-vm> <4F040B25.1080405@canonical.com>
	 <4F04452C.7020209@canonical.com> <18544246.20120104141703@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010418-9360-0000-0000-000002179BA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 14:17 +0100, Sander Eikelenboom wrote:

> Has there been a request to revert this for 3.2 final gone to Linus ?

Yep. I just sent a changelog for the revert commit to Linus.

thanks
-john


