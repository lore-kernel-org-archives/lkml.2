Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab2DJU33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:29:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab2DJU32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:29:28 -0400
From: Paul Moore <pmoore@redhat.com>
To: Josh Boyer <jwboyer@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: ANN: libseccomp
Date: Tue, 10 Apr 2012 16:29:17 -0400
Message-ID: <1673842.NkbWD6ec4k@sifl>
Organization: Red Hat
User-Agent: KMail/4.8.2 (Linux/3.3.1-gentoo; KDE/4.8.2; x86_64; ; )
In-Reply-To: <1524909.RpscfJeEfO@sifl>
References: <1540670.AFBi1SpGoi@sifl> <CA+5PVA6vQF5T4j2-GoURrLshzCybELd-Hn3cgEd5nHVcQgNV7w@mail.gmail.com> <1524909.RpscfJeEfO@sifl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 09, 2012 05:28:41 PM Paul Moore wrote:
> On Monday, April 09, 2012 04:14:15 PM Josh Boyer wrote:
> > On Mon, Apr 9, 2012 at 4:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > > On 04/09/2012 12:25 PM, Josh Boyer wrote:
> > >> Do you think the GPLv2 license will limit adoption of it's usage across
> > >> a wider variety of software projects?  I'm not anti-GPL by any means
> > >> but I am slightly surprised libseccomp is using it.
> > >> 
> > >> josh
> > > 
> > > Yes, on the surface of it this would seem more like LGPL material.
> > > 
> > > Other than that, very much needed!
> > 
> > Agreed on both points.  I only brought this up now as it's very early
> > in the project's lifetime.  If a relicense were to happen it would be
> > better to do it before a larger number of developers started
> > contributing to the project.
> 
> You both bring up a good point, the LGPL seems like a better choice.  I
> chose GPLv2 when I started simply out of habit; it is a license I am both
> familiar and comfortable with so it has a tendency to get used when I start
> a new chunk of code.
> 
> As you pointed out, the project is still very new with only a handful of
> authors beyond myself.  I'll get in touch with them privately to make sure
> they are comfortable with the relicense and assuming there are no problems
> I'll report back when everything has been changed.

Just an update, the project has just been relicensed under the LGPLv2.1 
license.

-- 
paul moore
security and virtualization @ redhat

