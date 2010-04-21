Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab0DUFLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:11:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0DUFLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:11:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [Bug #15795] 2.6.34-rc4 : OOPS in unmap_vma
Date: Wed, 21 Apr 2010 07:12:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.GdG.KRSzLB@tosh> <alpine.DEB.2.00.1004201623280.10496@parag-laptop>
In-Reply-To: <alpine.DEB.2.00.1004201623280.10496@parag-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004210712.26169.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010, Parag Warudkar wrote:
> 
> On Tue, 20 Apr 2010, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15795
> > Subject		: 2.6.34-rc4 : OOPS in unmap_vma
> > Submitter	: Parag Warudkar <parag.lkml@gmail.com>
> > Date		: 2010-04-14 (6 days old)
> > Message-ID	: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
> > References	: http://marc.info/?l=linux-kernel&m=127121006625429&w=2
> > 
> > 
> > 
> 
> Hasn't reproduced after many retries and I am not sure it can be called a 
> regression, may be it's always been there, just not reproducible easily - 
> let's close this, I will reopen if needed.

Done.

Rafael
