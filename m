Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1HBLKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:10:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36591 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1HBLKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:10:42 -0400
Date: Tue, 2 Aug 2011 13:10:39 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
        Tino Keitel <tino.keitel@tikei.de>, mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in
 3.0.0-rc7
Message-ID: <20110802131039.0972ff30@schatten.dmk.lab>
In-Reply-To: <20110802124028.3b8dcd5a@schatten.dmk.lab>
References: <20110722192722.GA9369@x61.home>
	<20110802085447.GA4522@shale.localdomain>
	<20110802115145.25b6a445@schatten.dmk.lab>
	<20110802124028.3b8dcd5a@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 12:40:28 +0200
Florian Mickler <florian@mickler.org> wrote:

> This should fix it. 
> 
Tino, can you test if this also fixes your bug since
 I don't have the hardware. 

At the moment I'm not seeing how the screwup Dan pointed out could
have that effect though... ? The priv-buffer-pointer would have
been simply overriden in the probe routine by the new buffer and it
should have worked happily everafter (until the driver disconnect
routine would have been called...) *headscratch*

Regards,
Flo
