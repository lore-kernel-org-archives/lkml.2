Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0CSA3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:29:44 -0400
Received: from kroah.org ([198.145.64.141]:46530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0CSA3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:29:42 -0400
Date: Thu, 18 Mar 2010 17:04:38 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Greg KH <gregkh@suse.de>, Peter Stuge <peter@stuge.se>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       stable-review@kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [patch 070/123] ath9k: re-enable ps
 by default for new single chip families
Message-ID: <20100319000438.GV5454@kroah.com>
References: <20100313001618.GA9811@kroah.com>
 <20100313001511.285517122@kvm.kroah.org>
 <43e72e891003151804s617659f8o6dcbf0b5ab63cb5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43e72e891003151804s617659f8o6dcbf0b5ab63cb5d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 06:04:15PM -0700, Luis R. Rodriguez wrote:
> On Fri, Mar 12, 2010 at 5:12 PM, Greg KH <gregkh@suse.de> wrote:
> > 2.6.33-stable review patch.  If anyone has any objections, please let me know.
> 
> This was intended for 2.6.32 as well. Thanks

Great, but it didn't apply there, so I didn't try to force it :)

Care to provide a backport?

thanks,

greg k-h
