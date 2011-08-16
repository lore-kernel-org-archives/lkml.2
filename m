Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1HPKHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 06:07:00 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38295 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752064Ab1HPKG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 06:06:58 -0400
Date: Tue, 16 Aug 2011 11:05:45 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Jayachandran C." <jayachandranc@netlogicmicro.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 02/11] arch/mips: do not use EXTRA_CFLAGS
Message-ID: <20110816100544.GA12658@linux-mips.org>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
 <1313384834-24433-3-git-send-email-lacombar@gmail.com>
 <4E48EAA0.5020901@mvista.com>
 <20110815135515.GA1441@linux-mips.org>
 <CACqU3MVyg_hA1m+1sJZ+aTHdxvzxviVXr0Fvom7p9EEHXVOMtA@mail.gmail.com>
 <CA+7sy7DEBgcUYCf895yf8cKMS=iDgz-n9Nh7R8_EO_O-QX3MfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+7sy7DEBgcUYCf895yf8cKMS=iDgz-n9Nh7R8_EO_O-QX3MfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 10:58:27PM +0530, Jayachandran C. wrote:

> On Mon, Aug 15, 2011 at 9:49 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > Hi,
> >
> > On Mon, Aug 15, 2011 at 9:55 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> >> On Mon, Aug 15, 2011 at 01:45:04PM +0400, Sergei Shtylyov wrote:
> >>
> >>>    You didn't sign off.
> >>
> >> True - but I won't make a big fuzz about that for a one-line.  I'm sure
> >> Arnaud will vow to do right the next time :-)
> >>
> > You are welcome to slap me. If it's not too late:
> >
> > Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> 
> Thanks for fixing this up.   Looks like an acked-by is not needed :)

No - but generally an Acked-by: a maintainer or Reviewed-by: or Tested-by:
somebody else is always welcome.  The more eyeballs, the better :-)

  Ralf
