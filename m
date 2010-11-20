Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0KTPxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 10:53:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0KTPxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 10:53:11 -0500
Date: Sat, 20 Nov 2010 07:52:51 -0800
From: Greg KH <gregkh@suse.de>
To: Andy Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/66] 2.6.36.1-stable review
Message-ID: <20101120155251.GB28803@suse.de>
References: <20101119220309.GA15562@kroah.com> <4CE7DA05.8050605@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE7DA05.8050605@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 09:24:05AM -0500, Andy Lutomirski wrote:
> Greg KH wrote:
>> This is the start of the stable review cycle for the 2.6.36.1 release.
>> There are 66 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let us know.  If anyone is a maintainer of the proper subsystem, and
>> wants to add a Signed-off-by: line to the patch, please respond with it.
>
> Can you add ab838338a2a9e0cb8346eb0cab9977be13e8dce5?  (Somehow the cc: 
> stable got eaten, but 2.6.36 definitely needs this one.  2.6.35 probably 
> does as well but I haven't tested it.)

Please get an ack from the maintainer of that driver and the drm
maintainer so that I can apply it to the next .36 queue.

thanks,

greg k-h
