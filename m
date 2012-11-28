Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2K1KGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:06:02 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:49021 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2K1KF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:05:59 -0500
Date: Wed, 28 Nov 2012 11:05:57 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] [PATCH] fix infinite loop; increase robustness of
 debugfs_remove_recursive [attached test module]
Message-ID: <20121128100557.GB674@soda.linbit>
References: <20121123171547.GB23670@soda.linbit>
 <1354072588.6276.101.camel@gandalf.local.home>
 <20121128093754.GA674@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128093754.GA674@soda.linbit>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:37:54AM +0100, Lars Ellenberg wrote:
> Note that all but rmmod may be done as normal user,

Ok, that is not exactly correct,
I forgot about debugfs being mounted 0700 ;-)

Still...

	Lars
