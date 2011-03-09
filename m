Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1CIAJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:09:44 -0500
Received: from kroah.org ([198.145.64.141]:49500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab1CIAJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:09:42 -0500
Date: Tue, 8 Mar 2011 16:09:32 -0800
From: Greg KH <greg@kroah.com>
To: Minkyu Kang <promsoft@gmail.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kyungmin.park@samsung.com, Ben Dooks <ben-i2c@fluff.org>
Subject: Re: [PATCH v3] misc: adds support the FSA9480 USB Switch
Message-ID: <20110309000932.GA12470@kroah.com>
References: <4D75D338.9070801@samsung.com>
 <20110308135909.GA7519@kroah.com>
 <AANLkTi=cgOJK=xGpbM8zaTVHcF+ZzjTCds+6dw3zAN_P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=cgOJK=xGpbM8zaTVHcF+ZzjTCds+6dw3zAN_P@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 08:59:18AM +0900, Minkyu Kang wrote:
> Dear Greg KH,
> 
> On 8 March 2011 22:59, Greg KH <greg@kroah.com> wrote:
> > On Tue, Mar 08, 2011 at 03:56:56PM +0900, Minkyu Kang wrote:
> >> --- /dev/null
> >> +++ b/include/linux/fsa9480.h
> >
> > Why do you need a .h file for this driver?
> >
> > If it's just for platform data, please put it in
> > include/linux/platform_data/ instead.
> 
> Yes, it's for platform data.
> But, sorry I couldn't find such a directory.
> Where?

It's in the linux-next tree, you can create that file in your patch.

thanks,

greg k-h
