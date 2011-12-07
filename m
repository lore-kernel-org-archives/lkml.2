Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1LGQkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:40:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab1LGQki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:40:38 -0500
Date: Wed, 7 Dec 2011 08:38:38 -0800
From: Greg KH <gregkh@suse.de>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [092/104] iwlwifi: do not re-configure HT40 after associated
Message-ID: <20111207163838.GA17552@suse.de>
References: <20111207161222.332098846@clark.kroah.org>
 <1323271793.13074.52.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323271793.13074.52.camel@wwguy-huron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 07:29:53AM -0800, Guy, Wey-Yi wrote:
> Hi Greg,
> 
> Just found out this might also needed for 3.0.
> I am not sure it will apply, should I submit separated patch?

As it didn't apply, yes, please send a patch for this to
stable@vger.kernel.org.

thanks,

greg k-h
