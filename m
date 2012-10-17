Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2JQJcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 05:32:03 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:53671 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab2JQJcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 05:32:01 -0400
Date: Wed, 17 Oct 2012 11:31:53 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap : make lock/unlock functions customizable.
Message-ID: <20121017093153.GB20531@mail.gnudd.com>
References: <1350395819-31108-1-git-send-email-ciminaghi@gnudd.com> <20121017075633.GK14199@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121017075633.GK14199@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 04:56:35PM +0900, Mark Brown wrote:
> On Tue, Oct 16, 2012 at 03:56:59PM +0200, ciminaghi@gnudd.com wrote:
> > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> > 
> > It is sometimes convenient for a regmap user to override the standard
> > regmap lock/unlock functions with custom functions.
> 
> Applied, thanks.  Please use changelog entries matching the subsystem
> and fix the formatting of your changelog to have blank lines between
> paragraphs.

sorry, I'll try to be more careful next time.
Thanks for your patience.

Regards
Davide

