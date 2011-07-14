Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1GNK0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 06:26:39 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:49787 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1GNK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 06:26:38 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRNV67U=
X-RZG-CLASS-ID: mo00
Date: Thu, 14 Jul 2011 12:26:28 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: Ian.Campbell@citrix.com, konrad.wilk@oracle.com, keir@xen.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
Message-ID: <20110714102628.GA9157@aepfle.de>
References: <4E1DB9C70200007800072DCC@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E1DB9C70200007800072DCC@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, Jan Beulich wrote:

> >>> Ian Campbell <Ian.Campbell@citrix.com> 07/13/11 11:12 AM >>>
> >It's not so much an objection to this patch but this issue seems to have
> >been caused by Xen cset 20892:d311d1efc25e which looks to me like a
> >subtle ABI breakage for guests. Perhaps we should introduce a feature
> >flag to indicate that a guest can cope with the m2p changing size over
> >migration like this?
> 
> Indeed - migration was completely beyond my consideration when
> submitting this. A feature flag seems the right way to go to me.

I will prepare a patch for a new feature flag.

Olaf
