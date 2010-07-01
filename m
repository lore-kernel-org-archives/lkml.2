Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0GAX3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:29:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29707 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0GAX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:29:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46078998"
Subject: Re: Closed source userspace graphics drivers with an open source 
 kernel component
From: Daniel Walker <dwalker@codeaurora.org>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-arm-msm@vger.kernel.org, jcrouse@codeaurora.org
In-Reply-To: <AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	 <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
	 <1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 16:29:35 -0700
Message-ID: <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 08:57 +1000, Dave Airlie wrote:
> On Fri, Jul 2, 2010 at 8:51 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> > On Fri, 2010-07-02 at 08:36 +1000, Dave Airlie wrote:
> >> On Fri, Jul 2, 2010 at 8:10 AM, Dave Airlie <airlied@gmail.com> wrote:
> >> > Now this is just my opinion as maintainer of the drm, and doesn't
> >> > reflect anyone or any official policy, I've also no idea if Linus
> >> > agrees or not.
> >> >
> >> > We are going to start to see a number of companies in the embedded
> >> > space submitting 3D drivers for mobile devices to the kernel. I'd like
> >> > to clarify my position once so they don't all come asking the same
> >> > questions.
> >> >
> >> > If you aren't going to create an open userspace driver (either MIT or
> >> > LGPL) then don't waste time submitting a kernel driver to me.
> >
> > If , for whatever reason, you changed you mind on this what sort of
> > connection between kernel and userspace would these components use?
> >
> > I ask only because I think UIO hold most (if not all) the driver in
> > userspace .. So you would have to use some other interface if you wanted
> > a more half and half solution ..
> >
> 
> The thing is UIO doesn't solve the problem 3D graphics drivers need to
> solve. Which is we need to let unprivileged users access the graphics
> device in an efficient manner, hence why DRI/DRM exists. Now I think
> the tegra guys have done some evil hacks with a userspace daemon to
> replace the kernel functionality, so all they have in-kernel is a
> framebuffer device, since they can't really get away with shipping the
> binary nvidia driver linked to the kernel in a real device. So all
> their userspace closed bits talk to the daemon running as root with
> direct access to the lowlevel hw.

Oh, man .. It seems like any driver model that straddles userspace and
kernel space is kind of asking for trouble (my opinion anyway)..

Would you accept a userspace component that supported some subset of the
features ? You would have a kernel space driver, and userspace both open
source and GPL'd , but the userspace component wouldn't support ever
feature available .. Then the company would be free to make another
proprietary userspace with more features based off the open source one.

Daniel
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

