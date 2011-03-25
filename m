Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1CYOrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:47:11 -0400
Received: from xes-mad.com ([216.165.139.218]:19682 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1CYOrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:47:10 -0400
Subject: RE: [PATCH] gpio: ml_ioh_gpio: Fix output value of
 ioh_gpio_direction_output()
From: Peter Tyser <ptyser@xes-inc.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, "'Grant Likely'" <grant.likely@secretlab.ca>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
In-Reply-To: <C734E3BF5C7F418896D57EBBD1C709C4@hacdom.okisemi.com>
References: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
	 <C734E3BF5C7F418896D57EBBD1C709C4@hacdom.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 09:47:01 -0500
Message-ID: <1301064421.24947.231.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On Fri, 2011-03-25 at 09:31 +0900, Tomoya MORINAGA wrote:
> Hi Peter,
> 
> On Friday, March 25, 2011 8:17 AM, Peter Tyser wrote:
> 
> > The ioh_gpio_direction_output() function was missing a write 
> > to set the desired output value.  The function would properly 
> > set the GPIO direction, but not the output value.  The value 
> > would have to manually be set with a follow up call to ioh_gpio_set().
> 
> > This is untested - just noticed it while working on an 
> > unrelated change.  An ack or tested-by from someone with real 
> > hardware would be appreciated.
> 
> Thank you for your indication.
> Your saying is right.
> However since your patch looks incorrect,
> after testing, I will post new patch by next week.

Out of curiosity, what looks incorrect about the patch?  The code to set
the GPIO value is identical to the code in ioh_gpio_set(), which was the
old code path.

Best,
Peter

