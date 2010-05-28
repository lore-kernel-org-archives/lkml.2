Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0E1KEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:04:13 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5296 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135Ab0E1KEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:04:08 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o4SA38eQ029525
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527212852.GA9859@srcf.ucam.org>
References: <20100527210808.GB8865@srcf.ucam.org>
	 <Pine.LNX.4.44L0.1005271723200.3239-100000@iolanthe.rowland.org>
	 <20100527212852.GA9859@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 12:03:08 +0200
Message-ID: <1275040988.20005.29.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-x.dcc-servers-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2010-05-27 at 22:28 +0100, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 05:24:28PM -0400, Alan Stern wrote:
> 
> > Would it help to divide the application into two processes, one of 
> > which receives events and the other does the drawing?
> 
> At the point where you're rewriting the application you can just make it 
> adhere to our current behavioural standards anyway.

Thank you for confirming that the so-called "feature" is just there to
make apps work in some area that are crappy anyways - and God knows in
which other areas they are crappy too.

SCNR,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

