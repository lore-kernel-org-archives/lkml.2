Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1FHQdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:33:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1FHQdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:33:01 -0400
Date: Wed, 8 Jun 2011 09:26:13 -0700
From: Greg KH <gregkh@suse.de>
To: "Clark, Joel" <joel.clark@intel.com>
Cc: "Cox, Alan" <alan.cox@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        "'Tomoya MORINAGA'" <tomoya-linux@dsn.okisemi.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>,
        "Skarpness, Mark" <mark.skarpness@intel.com>
Subject: Re: FW: [PATCH v5] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110608162613.GA7005@suse.de>
References: <667A27282ACF7941B0F557DAD3491E16010A9E12CB@rrsmsx504.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <667A27282ACF7941B0F557DAD3491E16010A9E12CB@rrsmsx504.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 05:26:42AM -0600, Clark, Joel wrote:
> We would like to add this fix as soon as it is acceptable.

Add it to what?

> Will this version of this patch be accepted and applied?

It's already in linux-next and will be sent to Linus in a few days for
inclusion in the final 3.0 release.

greg k-h
