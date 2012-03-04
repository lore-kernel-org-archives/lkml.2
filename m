Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2CDASR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:18:17 -0500
Received: from solo.fdn.fr ([80.67.169.19]:36938 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab2CDASQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:18:16 -0500
Date: Sun, 4 Mar 2012 01:18:06 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "John G. Heim" <jheim@math.wisc.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: speakup bug
Message-ID: <20120304001806.GO4180@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"John G. Heim" <jheim@math.wisc.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
 <20120303173916.7eca9391@pyramind.ukuu.org.uk>
 <FD8CB954D8084F998E24C4558E41C627@hinkle>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FD8CB954D8084F998E24C4558E41C627@hinkle>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John G. Heim, le Sat 03 Mar 2012 18:01:07 -0600, a écrit :
> >The speakup people have been told this repeatedly for years and years

And the kernel hasn't really provided the feature for speakup to use it
for years and years.

> >which is why their drivers work on less and less systems and won't run
> >with things PCI or USB serial ports, and why they are forever buried in
> >staging.
> 
> Do you recall if they gave a reason for not wanting to use the serial layer?

Because no such facility really exists, it still has to to be done
before speakup can use it. It's on my TODO list for years now, and still
haven't found the time to work on it.

> I don't even know what the serial layer is (although the name is descriptive
> enough and I can guess).But I would think they'd have had some reason for
> not wanting to do that.

It's definitely not a "not want", but "can not use what does not exist".

Just for the record: what we need is being able to open a serial port
and read/write from inside the kernel. Using a daemon that does the open
and setting up speakup as a line discipline would be possible, but it
then depends on / working, and that's not something e.g. administrators
can really afford depending on.

Samuel
