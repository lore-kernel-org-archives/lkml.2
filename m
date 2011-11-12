Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1KLNvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 08:51:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43374 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1KLNvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 08:51:05 -0500
Date: Sat, 12 Nov 2011 14:50:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Drake <dsd@laptop.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
Message-ID: <20111112135059.GA2009@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Drake <dsd@laptop.org>, Borislav Petkov <bp@amd64.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
 <20111108203116.GF25083@aftab>
 <4EB9A6BC.7050600@zytor.com>
 <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
 <CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com>
 <20111108223744.GA1996@x1.osrc.amd.com>
 <CAMLZHHRc+yNr=6SB7Z1t_hyL+e8a0T-BokyQ+wVUPw-vhd3rQA@mail.gmail.com>
 <20111109173412.GE14181@aftab>
 <CAMLZHHRJdumbbuBtHnAOtLRCzgBrKQw-PHCeeG=WEs5KeKsKGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMLZHHRJdumbbuBtHnAOtLRCzgBrKQw-PHCeeG=WEs5KeKsKGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 12:40:15PM -0600, Daniel Drake wrote:
> On Wed, Nov 9, 2011 at 11:34 AM, Borislav Petkov <bp@amd64.org> wrote:
> > On Tue, Nov 08, 2011 at 04:59:05PM -0600, Daniel Drake wrote:
> >> On Tue, Nov 8, 2011 at 4:37 PM, Borislav Petkov <bp@alien8.de> wrote:
> >> > Yep, just send me /proc/cpuinfo from a working kernel.
> >
> > Daniel, would you please test? It should work though :-)
> 
> Thanks, it boots now.

Cool, thanks, I'll add your Tested-by: and send out.

-- 
Regards/Gruss,
   Boris
