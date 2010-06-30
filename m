Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0F3NoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:44:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:33955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0F3NoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:44:17 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Przemo Firszt <przemo@firszt.eu>
Subject: Re: [PATCH] Expose vendor-specific ACM channel on Nokia 5230
Date: Wed, 30 Jun 2010 15:43:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-9-desktop; KDE/4.4.3; x86_64; ; )
Cc: oliver@neukum.name, gregkh@suse.de, alan@linux.intel.com,
       francescolavra@interfree.it, julian.calaby@gmail.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1277756974-3373-1-git-send-email-przemo@firszt.eu> <201006282259.11598.oliver@neukum.org> <1277833403.4123.2.camel@pldmachine>
In-Reply-To: <1277833403.4123.2.camel@pldmachine>
Organization: SUSE
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301543.17369.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Juni 2010, 19:43:23 schrieb Przemo Firszt:
> Dnia 2010-06-28, pon o godzinie 22:59 +0200, Oliver Neukum pisze:
> > Am Montag, 28. Juni 2010, 22:29:34 schrieb Przemo Firszt:
> > > Nokia S60 phones expose two ACM channels. The first is
> > > a modem, the second is 'vendor-specific' but is treated
> > > as a serial device at the S60 end, so we want to expose
> > > it on Linux too.
> > > 
> > 
> > I see. We want to expose it. But do we want to expose it as an acm interface?
> > 
> > 	Regards
> > 		Oliver
> It's just continuation of [1]. I don't feel pressure to do it that way
> if there are any better ideas.

I see. Let's do it.

	Regards
		Oliver
