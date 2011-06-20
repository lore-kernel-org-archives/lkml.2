Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1FTWdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:33:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53980 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1FTWdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:33:38 -0400
Date: Mon, 20 Jun 2011 15:16:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.0-rc3] tree RCU boost vs hang notifier...
Message-ID: <20110620221642.GD2933@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTin2osfkSiu8maGmJAnzv4O5ODK0dw@mail.gmail.com>
 <20110614045150.GA2264@linux.vnet.ibm.com>
 <BANLkTinvygi9aSkFcnOs2CHCmExD2ixJuQ@mail.gmail.com>
 <20110614124048.GB2264@linux.vnet.ibm.com>
 <pan.2011.06.17.11.44.00@message-id.slipkonture.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2011.06.17.11.44.00@message-id.slipkonture.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:44:02AM +0000, Stefan Seyfried wrote:
> On Tue, 14 Jun 2011 05:40:48 -0700, Paul E. McKenney wrote:
> 
> > On Tue, Jun 14, 2011 at 01:46:04PM +0800, Daniel J Blueman wrote:
> >> Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
> > 
> > Thank you very much for testing this!
> 
> Hi Paul,
> 
> Will this also fix the constant system load of 1.0 or is this a different 
> issue? (If it was, I'd need to report it properly ;)

Hello, Stefan,

Yes, it should also reduce the system load, given that the load
calculations count tasks sleeping uninteruptably but not tasks
sleeping interruptably.

							Thanx, Paul
