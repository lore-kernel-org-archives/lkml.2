Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1IUPr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:47:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1IUPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:47:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6475"; a="120401795"
Date: Wed, 21 Sep 2011 10:47:41 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: realmz paranoid <realmz6@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 21/36] Hexagon: Add SMP support
Message-ID: <20110921154741.GB6006@codeaurora.org>
References: <093448$3hstu8@wolverine01.qualcomm.com>
 <CAMk6uBmBqJsYSW+X9iY8Zc6BaC0jRy+a0CW0UV93gBAo98CzyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMk6uBmBqJsYSW+X9iY8Zc6BaC0jRy+a0CW0UV93gBAo98CzyA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 10:10:27AM +0800, realmz paranoid wrote:
> > +/*
> > + * called once for each present cpu
> > + * apparently starts up the CPU and then
> > + * maintains control until "cpu_online(cpu)" is set.
> > + */
> > +
> __cpu_up only called once?

Well, for us currently, I'm pretty sure it's called only once, but perhaps
I should be a little more precise on the comment.


Thanks,
Richard Kuo

