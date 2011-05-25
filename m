Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1EYJOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:14:10 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:39006 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1EYJOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:14:09 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 11:13:52 +0200
In-Reply-To: <4DDCC1E4.706@fusionio.com>
References: <20110519222404.GG12600@redhat.com>
			 <20110521210013.GJ2271@linux.vnet.ibm.com>
			 <20110523152141.GB4019@redhat.com>
			 <20110523153848.GC2310@linux.vnet.ibm.com>
		 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com>
	 <1306312155.9059.8.camel@t41.thuisdomein> <4DDCC1E4.706@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306314848.9059.17.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 10:46 +0200, Jens Axboe wrote:
> Are you easily able to test a patch out?

Yes. 

> Having a
> test case on your machine that is as easily reproducible as it seems to
> be, would be a great place to test ideas out.

Maybe I should now also try to build CFQ (and the other schedulers, I
guess) as a module (instead of Fedora's default of builtin). That might
make it both easier and quicker to iterate over a number of ideas.

Does using the schedulers as modules require any handholding (on your
part, I'm afraid) or is it not really different from using any other
kernel module?


Paul Bolle

