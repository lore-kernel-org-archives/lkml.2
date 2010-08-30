Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0H3Nkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:40:36 -0400
Received: from plane.gmane.org ([80.91.229.3]:36710 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab0H3Nke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:40:34 -0400
Date: Mon, 30 Aug 2010 15:39:53 +0200
From: Florian Mickler <florian@mickler.org>
To: public-trapdoor6-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org
Newsgroups: gmane.linux.kernel.kernel-testers,gmane.linux.kernel
Cc: "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@plane.gmane.org>,
        Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Kernel Testers List 
	<public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Maciej Rutecki 
	<public-maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>
Subject: Re: [Bug #16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing
 textures in 0 A.D.
Message-ID: <20100830153953.1e5abc71@schatten.dmk.lab>
In-Reply-To: <AANLkTikpoH-_od-SL3=Q7a=xbsraE4rYGicx7mmS92Cw@mail.gmail.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.mj.QGueMB@chimera>
	<AANLkTikpoH-_od-SL3=Q7a=xbsraE4rYGicx7mmS92Cw@mail.gmail.com>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Aug 2010 10:54:41 +0100
trapDoor <trapdoor6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sun, Aug 29, 2010 at 11:36 PM, Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16881
> > Subject         : [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing textures in 0 A.D.
> > Submitter       :  <trapdoor6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Date            : 2010-08-24 12:20 (6 days old)
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> There was at least one drm pull between 2.6.36-rc2 and -rc3. So I
> tested on -rc3 and I confirm that the issue is still present.
> 
> I was going to update the bugzilla entry but it won't let me log in at
> this moment.
> 

It seems to work now again. I've updated the entry for you. 

Thx,
Flo

