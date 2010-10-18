Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0JRM2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:28:31 -0400
Received: from ns.mindbit.ro ([80.86.127.26]:57669 "EHLO ns.mindbit.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0JRM23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:28:29 -0400
X-Greylist: delayed 1285 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 08:28:29 EDT
Subject: Re: [PATCHv3 01/11] staging: tidspbridge: replace iommu custom for
 opensource implementation
From: Ionut Nicu <ionut.nicu@mindbit.ro>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Fernando Guzman Lugo <x0095840@ti.com>, gregkh@suse.de,
        felipe.contreras@nokia.com, ameya.palande@nokia.com, nm@ti.com,
        Hiroshi.DOYU@nokia.com, ohad@wizery.com, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, linux-omap@vger.kernel.org
In-Reply-To: <AANLkTin+n8KsHz2jTtkbk2MnuiANrxpskThYU9FVu3CE@mail.gmail.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
	 <1286310944-25035-2-git-send-email-x0095840@ti.com>
	 <AANLkTin+n8KsHz2jTtkbk2MnuiANrxpskThYU9FVu3CE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MindBit
Date: Mon, 18 Oct 2010 15:06:29 +0300
Message-ID: <1287403590.2916.24.camel@atlantis.mindbit.ro>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-10-18 at 01:36 +0300, Felipe Contreras wrote: 
> On Tue, Oct 5, 2010 at 11:35 PM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> > Now the tidspbridge uses the API's from
> > iovmm module.
> >
> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> 
> NAK. This patch doesn't work... I guess it's supposed to.
> 
> So far I've found these errors, but it still doesn't work, maybe we
> should start thinking of reverting the whole iommu stuff:
> 

I also tested it with the userspace-dspbridge tools and it doesn't work
for me either.

Maybe it's better to revert this patch series for now and re-submit it
when all necessary patches get merged and it actually works on top of
the staging-next tree?

Regards,
Ionut.

