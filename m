Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2KFEns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 23:43:48 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:48938 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2KFEnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 23:43:47 -0500
Date: Tue, 6 Nov 2012 05:43:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Matteo Croce <technoboy85@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Source updater script
Message-ID: <20121106044346.GA23799@kroah.com>
References: <CAFnufp3SdnBoFiC5j2bjrA=MW-WfsmFVhfggJvoHa-5ZEgg7aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFnufp3SdnBoFiC5j2bjrA=MW-WfsmFVhfggJvoHa-5ZEgg7aA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 12:52:46AM +0100, Matteo Croce wrote:
> Hi all,
> 
> I know that this is useless to people using git, but it was so fun to write
> and I use it to update regularly my pc kernel source from time to time
> while saving servers (and home) bandwidth

Have you looked at the python script called 'ketchup'?  I think it
already does a lot of what you are doing here.

greg k-h
