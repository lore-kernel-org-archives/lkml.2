Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab1KHWkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:40:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57652 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab1KHWko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:40:44 -0500
Date: Tue, 8 Nov 2011 23:40:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Daniel Drake <dsd@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
Message-ID: <20111108224041.GB1996@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
	Daniel Drake <dsd@laptop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
 <20111108203116.GF25083@aftab>
 <4EB9A6BC.7050600@zytor.com>
 <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
 <4EB9AAF1.4040103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EB9AAF1.4040103@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 02:19:29PM -0800, H. Peter Anvin wrote:
> Either that, or make changes so that we can handle exceptions earlier.
> That would be useful for other reasons.

I'd propose to do the trivial fix first so that Daniel can boot his box
and I'll look into the exception tables deal a bit later, when I get
unswamped.

Thanks.

-- 
Regards/Gruss,
   Boris
