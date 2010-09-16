Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0IPW5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:57:13 -0400
Received: from kroah.org ([198.145.64.141]:40526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab0IPW5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:57:12 -0400
Date: Thu, 16 Sep 2010 15:53:46 -0700
From: Greg KH <greg@kroah.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCHv2 01/10] staging: rt2860: change plain format of mac
 address to %pM in *printf()
Message-ID: <20100916225346.GA14448@kroah.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
 <20100916193249.GD10397@kroah.com>
 <AANLkTin_fs+moDjvd18H4QwMF1y0EXFq7tr3dq20JDoa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin_fs+moDjvd18H4QwMF1y0EXFq7tr3dq20JDoa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 01:45:48AM +0300, Andy Shevchenko wrote:
> On Thu, Sep 16, 2010 at 10:32 PM, Greg KH <greg@kroah.com> wrote:
> > If so, care to send me the remaining pieces and I'll apply
> > them?
> Do I understand correctly I need to prepare correction series with
> changes between v1 and v2?

Yes.

> P.S. In one patch in v1 series there was a typo as well.

Ick, yeah, sorry about that, the differences between the two is what I
need to apply to fix up the issues.

thanks,

greg k-h
