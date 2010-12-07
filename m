Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0LGUhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:37:16 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:50648 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754786Ab0LGUhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:37:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qD8jmEecScD0BSXM0/q/QSB5j6bEbPxeaidVXPMpMoZYEis0QzeETHEXFozK0S1VUMD187NPjpoJiy5UxCuqC0N2gcD5ugbsrmCXVOto8FY/kCDoSsQOIh8QG3QMB6Ma;
Date: Tue, 7 Dec 2010 12:37:10 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: microcai@fedoraproject.org
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101207123710.4d0e16af@jbarnes-desktop>
In-Reply-To: <1291025577.9785.7.camel@cai.gentoo>
References: <1290941875.13526.15.camel@cai.gentoo>
	<87mxosla7p.fsf@basil.nowhere.org>
	<1291025577.9785.7.camel@cai.gentoo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 18:12:57 +0800
Microcai <microcai@fedoraproject.org> wrote:

> 在 2010-11-29一的 11:01 +0100，Andi Kleen写道：
> 
> > To be honest I have doubts its worth it. This was discussed years and
> > years ago and the conclusion back then that people who need unicode
> > fonts should use them in X or another graphical console environment
> > (there are plenty to chose from these days). Has this changed?
> > 
> > -Andi
> > 
> 
> Yes, it change. Linux graphical stuck have changed a lot. With KMS,
> console got a native resolution, and looks very nice.

But really, keep this stuff out of the kernel.  Sure, the kernel can
provide memory and a framebuffer to draw in (subject to the constraints
Jerome already mentioned), but why try to deal with fancy input or font
handling there?  IMO the kernel console should be limited to printing
debug and error information; a separate userspace daemon should handle
input and console support.  It would be great to avoid the need for
CONFIG_VT entirely for the typical Linux system.

-- 
Jesse Barnes, Intel Open Source Technology Center
