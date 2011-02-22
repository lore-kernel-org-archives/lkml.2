Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1BVPK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:10:27 -0500
Received: from mail04do.versatel.de ([89.245.129.24]:46729 "EHLO
	mail04do.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1BVPK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:10:26 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 10:10:25 EST
Message-ID: <4D63D062.3040404@versanet.de>
Date: Tue, 22 Feb 2011 16:04:02 +0100
From: "pantherchen@versanet.de" <pantherchen@versanet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110208 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
References: <4D62CE9C.7090806@versanet.de> <20110222081752.GP31267@htj.dyndns.org> <20110222085223.GC11681@core.coreip.homeip.net> <20110222090255.GR31267@htj.dyndns.org> <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com>
In-Reply-To: <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:15 AM, Dmitry Torokhov wrote:
> I'd like to see rc6 tried.

Unfortunately it shows the same behavior [0]. (To speed things up, I 
used a stripped down kernel config [1], while the first two posted boot 
charts used Ubuntu's stock kernels.)

I was surprised that the kernel directly built from the wq branch and 
the last "good" kernel from Linus' tree with the 33 patches applied 
don't show the increased boot time - shouldn't they all be the same?

About the system: Lenovo ThinkPad T510 with an Core i5-560m, 6 GB RAM, a 
SSD, and hybrid graphics (can boot from either the Intel HD or the 
Nvidia NVS 3100M - regression shows up with both).

The system is running an up-to-date Ubuntu dev release (Natty) with Xorg 
7.6(~3ubuntu7), Xserver 1.9.99.901+git20110131.be3be758(-0ubuntu6), and 
Plymouth 0.8.2(-2ubuntu17) FWIW.

Thanks,

Hernando Torque

[0]: http://img.xrmb2.net/images/576186.png
[1]: http://paste.ubuntu.com/570595/
