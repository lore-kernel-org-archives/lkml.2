Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab1KBQCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:02:30 -0400
Received: from nm15-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.70]:39835 "HELO
	nm15-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932383Ab1KBQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:02:26 -0400
X-Yahoo-Newman-Id: 771684.87910.bm@smtp111.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Jg0Pr.UVM1mFKjTxJYTioLfJgUY8DANkYuVAShwQ7V0hqpB
 6D.vNFtLHDnuDmYEkM4SP9ceJnCrVsI5N8dRxtNU7w9wkGyMf6Qy.MkjPn8Y
 KvfALtINlj3LNGMYAB14_Y2pGF3lhxsmoza59UkRjPi5k8tfHIBpI9kixZf3
 reIqVNdJ0OXhT7K3GrbMrJJHZcyJQU.gLP0r95q3uRUcchYkzLn8Pz7I3skP
 34oDZTEt9cEnij2_zPlQ9tP_snjYv5hSbYRJy50p.VDNAH2VOKyaBm7HtVWV
 JWL6iI_SANGfKt17R7LqeHzCAMFpx0.ETjD83JMgNlV4N9lxe4_.7B27z4dJ
 b0UZp8oN6IwcU_5I4eNjq3JtM0T1lq8Po6SJYQy_0UAg8dKIlR6RYe3qLEMo
 AwygoI2lK__RfTduygGWIzLl3
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Wed, 2 Nov 2011 11:02:09 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        tj@kernel.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111102160208.GA6657@zeus>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102054658.GA29035@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 10:46:58PM -0700, Dmitry Torokhov wrote:
> 
> Are you hibernating from text console or X? Can you try plugging in USB
> keyboard and see if you are getting input? What about ssh into the box?

Forgot to answer a few of your questions. Plugging in a USB keyboard does
not help. And for now I cannot test whether the sshd daemon is reponsive
though it would seem that it would indeed be OK.

~ Andy
