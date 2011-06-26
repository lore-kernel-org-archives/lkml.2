Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1FZWjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:39:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1FZWhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:37:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Bug #38012] Missing code to load firmware
Date: Mon, 27 Jun 2011 00:38:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.UPD.fZ6BOB@chimera> <4E07AE64.1040707@lwfinger.net>
In-Reply-To: <4E07AE64.1040707@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106270038.47291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 27, 2011, Larry Finger wrote:
> On 06/26/2011 04:23 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38012
> > Subject		: Missing code to load firmware
> > Submitter	: Larry Finger<Larry.Finger@lwfinger.net>
> > Date		: 2011-06-20 21:44 (7 days old)
> > Handled-By	: Larry Finger<Larry.Finger@lwfinger.net>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=63002
> 
> The patch has been incorporated into Linville's wireless-testing tree and has 
> been pushed upstream. It should be in mainline soon.

Great, please close the bug when it hits mainline.

Thanks,
Rafael
