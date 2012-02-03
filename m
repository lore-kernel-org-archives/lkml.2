Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2BCTrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:47:31 -0500
Received: from imr4.ericy.com ([198.24.6.9]:43154 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab2BCTra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:47:30 -0500
Message-ID: <1328298346.2261.196.camel@groeck-laptop>
Subject: Re: [PATCH 1/3] mfd: Add LPC driver for Intel ICH chipsets
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Aaron Sierra <asierra@xes-inc.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Date: Fri, 3 Feb 2012 11:45:46 -0800
In-Reply-To: <098d7a9f-a5f9-4908-9253-f2134f08d932@zimbra>
References: <098d7a9f-a5f9-4908-9253-f2134f08d932@zimbra>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 14:35 -0500, Aaron Sierra wrote:
> > I ended up making all the changes suggested above (plus the matching
> > changes needed in the subsequent patches) while I rebased the code to
> > 3.3-rc2. Right now I have an (untested) patchset which applies to
> > 3.3-rc2. Please let me know how you would like to proceed; I can send
> > it to you if you like, or to the list.
> 
> Hey Guenter,
> If you want to send me your patchset directly, I can test it out on
> some of our hardware (Ibex Peak and Cougar Point). I can work on
> implementing some of your other suggestions as well before
> resubmitting to the list.
> 
Done. You should have received a series of four patches, your three plus
one with a number of changes I made on top of your first patch. The last
two patches are essentially yours modified to compile with 3.3-rc2 and
to work (hopefully ;) with my patch.

Thanks,
Guenter


