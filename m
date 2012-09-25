Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2IYSNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:13:54 -0400
Received: from nm14.bullet.mail.bf1.yahoo.com ([98.139.212.173]:38227 "HELO
	nm14.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752760Ab2IYSNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:13:52 -0400
X-Yahoo-Newman-Id: 373878.70814.bm@smtp113.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RxdWETsVM1mLCQIvLd6w4r6Jm9jPBIpmadmsqGUJlKJgAgX
 4YWp3qnzaJCSkRndc3mONq1.2l18moDTLc36KmvB_GD_opHgCSFj.52z6ehd
 8BZl9mrAlFiJ1mR4_52CbvkZzribHFLgDmkGAhVU5RmkW4tEgmAEWJ0z9eyC
 KABvZPieUNvFTyqOGthcIEN4qRxiNFJPk4_cSC.q_Ic1hj9iM3hQB8HgQ58d
 ryuWOGdAwt5G.x_dlzlBWRx3Jmj8VyU.bb6uj.ubTWupIJWMEMwyHDy9xo21
 v1qguKoHdevrwQWTx9JQx2Ki03vhCkmb97BjMtWjc3lZ33oFAWZywAylMjmj
 GqtD_ZSIKjumbO2llRfnggdnT7GToqAlOpXb6YhEU6yuCG3T7ApMvSq53Gnl
 0WUgpGS9IG6orLkjdV8nK2c1SGzew.YCrhYE1PC5s1YbLPzokBQ--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Tue, 25 Sep 2012 13:13:45 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG]: fsnotify oops on 3.5.2
Message-ID: <20120925181345.GA28930@ymail.com>
References: <20120826204453.GA10707@ymail.com>
 <20120827183428.GA21402@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827183428.GA21402@home.goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 02:34:28PM -0400, Steven Rostedt wrote:
> 
> Thanks for pointing out that the kernel is patched with overlayfs. As
> the crash is within the filesystem, it looks to be a bug with that
> patch. You may want to report this bug to them.
> 
> -- Steve

You were right. After reverting to 3.5.2 (sans overlayfs) the oops 
stopped. I will contact the overlyafs folks on the fs-devel list
and let them know.

~ Andy
