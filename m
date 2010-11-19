Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab0KSVD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:03:57 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:51022 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754057Ab0KSVD4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:03:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=W+JvDFQmi5iK2SQA3albu2BwUHg/A5/ACRTnFAMoP7Q6HJGA50mmx5jWMZp/XZBZmGnBvu267b/At4L6WELK2l0igi0z8sZdPh5a3MkPSTrUBB4btaj2jP2i6QmtFZ16;
Date: Fri, 19 Nov 2010 13:03:29 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        airlied@redhat.com, intel-gfx@lists.freedesktop.org
Subject: Re: Regressions in resume on intel graphics
Message-ID: <20101119130329.675ebf0b@jbarnes-desktop>
In-Reply-To: <AANLkTik4Bj2_D_oz8jWxzKSKz16S=Yv6884iHA072bJe@mail.gmail.com>
References: <AANLkTi=emVB3kqR322Man01sDd0DFecxzDENVCS6B1jj@mail.gmail.com>
	<AANLkTik4Bj2_D_oz8jWxzKSKz16S=Yv6884iHA072bJe@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 10:17:07 +0100
Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:

> 2010/11/12 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > Hi
> >
> > I've noticed that after resume  with 2.6.36 kernel I need to switch
> > between console and back to Xorg to get usable Xsession again.
> > (my hw - T61, gma965, 4GB)
> >
> > I've played bisect game -  and this is the first broken kernel:
> >
> > ---
> > commit 8fd4bd22350784d5b2fe9274f6790ba353976415
> > Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Date:   Wed Jun 23 12:56:12 2010 -0700
> >
> >    vt/console: try harder to print output when panicing
> > ---
> 
> I've been able to boot and test with 2.6.37-rc1-00170-gf6614b7
> - and this problem seems to be fixed in this version (vt.c file seems
> to be gone?).

This is really weird; there was one issue Dave tracked down related to
lockdep and the new oops code, but I think it's been fixed.  And it
should manifest as something other than a GPU hang...

-- 
Jesse Barnes, Intel Open Source Technology Center
