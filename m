Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1EFP6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:58:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47167 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab1EFP6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:58:14 -0400
Date: Fri, 6 May 2011 08:58:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: linux-next: Tree for May 6 (wireless)
Message-Id: <20110506085803.c15692bb.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTimqboATe5cO+19Bv5p9dStnwevwng@mail.gmail.com>
References: <20110506154921.47700781.sfr@canb.auug.org.au>
	<20110506084031.a1f2e483.randy.dunlap@oracle.com>
	<BANLkTimqboATe5cO+19Bv5p9dStnwevwng@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DC41A90.0074:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011 17:44:44 +0200 Sedat Dilek wrote:

> On Fri, May 6, 2011 at 5:40 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Fri, 6 May 2011 15:49:21 +1000 Stephen Rothwell wrote:
> >
> >> Hi all,
> >>
> >> Changes since 20110505:
> >
> >
> > when PM is not enabled:
> >
> > net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no member named 'suspend'
> > net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no member named 'resume'
> >
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-next" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> There was a patch sent today, see "[PATCH] mac80211: Fix build error
> when CONFIG_PM is not defined" from Larry.

Thanks.  That works.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
