Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0FGQ2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:28:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0FGQ23 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 7 Jun 2010 12:28:29 -0400
Date: Mon, 7 Jun 2010 12:28:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Robert Emanuele <rob@emanuele.us>
Cc: linux-kernel@vger.kernel.org, jayakumar.lkml@gmail.com
Subject: Re: broadsheetfb and fbcon
Message-ID: <20100607162817.GA13468@phenom.dumpdata.com>
References: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C0D1E29.00E7:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 04:21:08PM -0700, Robert Emanuele wrote:
> Greetings lkml and Jaya,
> 
> I've been using the broadsheetfb graphics driver for a while now.
> I've been trying to get it working with the fbcon console driver.  Has
> anyone had any success with that?
> 
> While it "works", its performance is unusable as a console.  It
> redraws the whole screen every new line, which may be acceptable.  A
> real issue is when it tries to scroll the screen, it redraws each line
> partially and then does a full screen update with each partial line.
> It seems the driver is capable from Jaya's video at
> http://www.youtube.com/watch?v=0Bny6qyRDWw
> 
> Are those kind of updates a limit of the broadsheet driver or fbcon?

I thought there was an update value on how often it should redraw. Did
you do a modinfo on the driver?
> Or more hopefully, is there a configuration change to improve this?
