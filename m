Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1IYBoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 21:44:03 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:16756 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab1IYBoB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 21:44:01 -0400
Date: Sun, 25 Sep 2011 02:43:57 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: radeon KMS (R100) on dell inspiron 5100 blank screen
Message-ID: <20110925014357.GA17885@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=D_TssLKpWT4A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=b4TMX27nrMCVcC53XNkA:9 a=wPNLvfGTeEIA:10 a=umOYGa_1N_ivRK6k:21 a=NXH96tcn_qF-qZEl:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend: mutt's reply-to-list didn't pick up Wakko's address, and my
manual fixup got the lkml address wrong - Wakko, sorry for spamming
your mailbox with this resend.

On Sat, Sep 24, 2011 at 08:17:23AM -0400, Wakko Warner wrote:
> Wakko Warner wrote:
> > My previous message, I stated in the subject line that this was a 5150. 
> > This is an inspiron 5100.
> 
> Noone?
> 
 One of my desktops uses an R100.  At the moment, I've not got time
to test kernels, but as of 3.0.0 and 3.0.4 it seems to be working ok
(with kms).

 What I *have* noticed for the last two years or so is that both
R100 and R200 often get broken by changes in the xorg area (both
the ati driver and Mesa have bitten me), and that the problem can
persist for a long time.  The reason for this is fairly obvious -
nobody doing development is using this old hardware, and those of
us who run it aren't following upstream development!

 If your problem is specific to a particular (old) laptop, the
number of people who are likely to experience the problem will be
even fewer.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce

----- End forwarded message -----

-- 
das eine Mal als Tragödie, das andere Mal als Farce
