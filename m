Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0FNPV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:21:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33691 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0FNPV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:21:26 -0400
Date: Mon, 14 Jun 2010 17:20:57 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Frederic Weisbecker <fweisbec@gmail.com>,
       markgross@thegnar.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [linux-pm] [PATCH v4] pm_qos: make update_request non blocking
Message-ID: <20100614172057.778a49d0@schatten.dmk.lab>
In-Reply-To: <1276528206.5374.24.camel@mulgrave.site>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	<1276097832.4343.223.camel@mulgrave.site>
	<20100609180033.39d5b499@schatten.dmk.lab>
	<1276099645.4343.257.camel@mulgrave.site>
	<20100609183204.1eeca494@schatten.dmk.lab>
	<1276103149.4343.350.camel@mulgrave.site>
	<20100610094525.0449d797@schatten.dmk.lab>
	<1276177144.27283.37.camel@mulgrave.site>
	<20100610164118.15ec7a05@schatten.dmk.lab>
	<1276266352.2862.70.camel@mulgrave.site>
	<20100614163339.755a2b5b@schatten.dmk.lab>
	<1276526646.5374.8.camel@mulgrave.site>
	<20100614164948.3b39d550@schatten.dmk.lab>
	<1276528206.5374.24.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 10:10:06 -0500
James Bottomley <James.Bottomley@suse.de> wrote:
 
> On closer inspection, it looks like the
> notifier mutexes are sufficient to make sure it doesn't return running
> the notifier to be removed ... but that does mean that add and remove
> require user context.
> 
> James
> 

Yes. I don't think we need to make the add and remove callable from
interrupt context?

Cheers,
Flo
