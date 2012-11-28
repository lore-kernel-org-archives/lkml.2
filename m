Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2K1A4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:56:46 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:58991 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754681Ab2K1A4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:56:45 -0500
Message-ID: <1354064192.2703.10.camel@thor>
Subject: Re: [PATCH -next] staging/fwserial: Fix build breakage when
 !CONFIG_BUG
From: Peter Hurley <peter@hurleysoftware.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 Nov 2012 19:56:32 -0500
In-Reply-To: <50B50985.1010700@infradead.org>
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
		 <50B3D767.70604@infradead.org> <1354000267.3284.4.camel@thor>
	 <50B50985.1010700@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 10:42 -0800, Randy Dunlap wrote:
> On 11/26/2012 11:11 PM, Peter Hurley wrote:
> 
> > Use WARN() as intended.
> > 
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> 
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Thanks.

Hi Randy,

I blew this, sorry.

First, I mistakenly sent the patch to Stephen rather than to Greg KH,
who's carrying this submission in staging-next. So I forwarded Greg the
patch when I realized my error. Which he committed. And Greg couldn't
catch my mistake because he didn't see the original chain. Then I got
your reminder email.

I won't let it happen again.
Peter

