Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0GAWva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:51:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12976 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0GAWv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:51:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46228047"
Subject: Re: Closed source userspace graphics drivers with an open source 
 kernel component
From: Daniel Walker <dwalker@codeaurora.org>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	 <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 15:51:18 -0700
Message-ID: <1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 08:36 +1000, Dave Airlie wrote:
> On Fri, Jul 2, 2010 at 8:10 AM, Dave Airlie <airlied@gmail.com> wrote:
> > Now this is just my opinion as maintainer of the drm, and doesn't
> > reflect anyone or any official policy, I've also no idea if Linus
> > agrees or not.
> >
> > We are going to start to see a number of companies in the embedded
> > space submitting 3D drivers for mobile devices to the kernel. I'd like
> > to clarify my position once so they don't all come asking the same
> > questions.
> >
> > If you aren't going to create an open userspace driver (either MIT or
> > LGPL) then don't waste time submitting a kernel driver to me.

If , for whatever reason, you changed you mind on this what sort of
connection between kernel and userspace would these components use?

I ask only because I think UIO hold most (if not all) the driver in
userspace .. So you would have to use some other interface if you wanted
a more half and half solution ..

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

