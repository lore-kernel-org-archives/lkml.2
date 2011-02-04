Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1BDLGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 06:06:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48293 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1BDLGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 06:06:30 -0500
Date: Fri, 4 Feb 2011 11:06:25 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH repost 4/4] avr32: at32ap700x: specify DMA src and dst
 masters
Message-ID: <20110204110625.GC9903@pulham.picochip.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
 <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
 <1295881154.2903.7.camel@hcegtvedt>
 <AANLkTimYqH1+ELS44Mg+cptgS9h8s09wdW+iSW5Feepk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimYqH1+ELS44Mg+cptgS9h8s09wdW+iSW5Feepk@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 29, 2011 at 10:33:26PM -0800, Dan Williams wrote:
> On Mon, Jan 24, 2011 at 6:59 AM, Hans-Christian Egtvedt
> <hans-christian.egtvedt@atmel.com> wrote:
> > On Fri, 2011-01-21 at 14:11 +0000, Jamie Iles wrote:
> >> Now that the dw_dmac DMA driver supports configurable source and
> >> destination masters we need to specify which ones to use. This was
> >> previously hardcoded to 0 and 1 respectively in the driver.
> >>
> >> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> >
> > Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> 
> I applied 1-4 will try to submit for 2.6.38 as these were ready before
> the merge window opened.

Thanks Dan!

Jamie
