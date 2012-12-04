Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2LDBou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:44:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34334 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2LDBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:44:49 -0500
Date: Mon, 3 Dec 2012 17:44:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Li Wu <willy.woo@gmail.com>
Cc: balbi@ti.com, Li Wu <li.wu@st.com>, Henrik Rydberg <rydberg@euromail.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Shawn Landden <shawnlandden@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jianchun <jcbian@pixcir.com.cn>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/1] Input: STMicroelectronics multi touch capacitive
 touchscreen ftk
Message-ID: <20121204014442.GA23039@core.coreip.homeip.net>
References: <1354285134-8188-1-git-send-email-willy.woo@gmail.com>
 <20121130150437.GE17587@arwen.pp.htv.fi>
 <CAEdoeCM94F3RT8J4w8i3S6GJ5Upy1CBCatnuwiFB_7ZzB0Cn6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEdoeCM94F3RT8J4w8i3S6GJ5Upy1CBCatnuwiFB_7ZzB0Cn6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Tue, Dec 04, 2012 at 08:32:05AM +0800, Li Wu wrote:
> Thanks Felipe for the nice comments.
> 
> I have consolidated most of your comments to a new version, but I am not
> sure how should I send it out.
> 
> I am using git send-email from shell command, then shall I just send out
> the patch v2? Or do I need send both v1 and v2?

Use "git rebase" to squash the 2 commit together and then send it out as
a single patch.

Thanks.

-- 
Dmitry
