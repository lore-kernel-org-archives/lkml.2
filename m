Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2DIV3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:29:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38149 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab2DIV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:29:06 -0400
From: Paul Moore <paul@paul-moore.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, libseccomp-discuss@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
Subject: Re: ANN: libseccomp
Date: Mon, 09 Apr 2012 17:28:41 -0400
Message-ID: <1524909.RpscfJeEfO@sifl>
User-Agent: KMail/4.8.2 (Linux/3.3.1-gentoo; KDE/4.8.2; x86_64; ; )
In-Reply-To: <CA+5PVA6vQF5T4j2-GoURrLshzCybELd-Hn3cgEd5nHVcQgNV7w@mail.gmail.com>
References: <1540670.AFBi1SpGoi@sifl> <4F83403F.3010609@zytor.com> <CA+5PVA6vQF5T4j2-GoURrLshzCybELd-Hn3cgEd5nHVcQgNV7w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 09, 2012 04:14:15 PM Josh Boyer wrote:
> On Mon, Apr 9, 2012 at 4:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 04/09/2012 12:25 PM, Josh Boyer wrote:
> >> Do you think the GPLv2 license will limit adoption of it's usage across
> >> a wider variety of software projects?  I'm not anti-GPL by any means
> >> but I am slightly surprised libseccomp is using it.
> >> 
> >> josh
> > 
> > Yes, on the surface of it this would seem more like LGPL material.
> > 
> > Other than that, very much needed!
> 
> Agreed on both points.  I only brought this up now as it's very early
> in the project's lifetime.  If a relicense were to happen it would be
> better to do it before a larger number of developers started
> contributing to the project.

You both bring up a good point, the LGPL seems like a better choice.  I chose 
GPLv2 when I started simply out of habit; it is a license I am both familiar 
and comfortable with so it has a tendency to get used when I start a new chunk 
of code.

As you pointed out, the project is still very new with only a handful of 
authors beyond myself.  I'll get in touch with them privately to make sure 
they are comfortable with the relicense and assuming there are no problems 
I'll report back when everything has been changed.

-- 
paul moore
www.paul-moore.com

