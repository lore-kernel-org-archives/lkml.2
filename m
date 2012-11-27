Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2K0HRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:17:39 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53794 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758103Ab2K0HRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:17:37 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2012 02:17:37 EST
Message-ID: <1354000650.3284.9.camel@thor>
Subject: Re: linux-next: Tree for Nov 26 (staging/fwserial)
From: Peter Hurley <peter@hurleysoftware.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 Nov 2012 02:17:30 -0500
In-Reply-To: <50B3D767.70604@infradead.org>
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
	 <50B3D767.70604@infradead.org>
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

On Mon, 2012-11-26 at 12:56 -0800, Randy Dunlap wrote:
> On 11/26/2012 06:17 AM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20121115:
> > 
> 
> 
> on i386:
> 
> drivers/staging/fwserial/dma_fifo.c: In function 'dma_fifo_in':
> drivers/staging/fwserial/dma_fifo.c:174:2: error: implicit declaration of function '__WARN_printf'

Apologies for the breakage. Not sure what possessed me to use an
internal macro so I could duplicate existing functionality...

Thanks for catching this now.


