Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab0KLTaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:30:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0KLTaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:30:16 -0500
Date: Fri, 12 Nov 2010 11:29:58 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Achatz <stefan_achatz@web.de>
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 1/2] sysfs: Introducing sysfs_create_bin_group()
Message-ID: <20101112192958.GA22233@suse.de>
References: <1289585918.2629.12.camel@neuromancer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289585918.2629.12.camel@neuromancer>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 07:18:38PM +0100, Stefan Achatz wrote:
> Implemented group functions for easier creation of multiple binary sysfs
> attributes similar to existing attribute_group handling functions.
> The code reuses struct attribute_group instead of inventing a new struct
> binary_attribute_group.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>

Looks good to me, nice job.

Dmitry, do you want to take this through your tree as the mouse driver
change needs it?  If so, feel free to do so and add a:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to the patch.

If not, I'll be glad to take it, and the mouse driver change through my
tree if needed.

Just let me know which is easier for you.

thanks,

greg k-h
