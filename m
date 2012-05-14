Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2ENUjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:39:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36477 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab2ENUjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:39:11 -0400
Date: Mon, 14 May 2012 13:39:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Please send a patch to set .gitignore to handle
 Documentation/misc-devices/mei/mei-amt-version
Message-ID: <20120514203906.GA11436@kroah.com>
References: <20120514201228.GA21466@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B102512@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B102512@HASMSX103.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 08:33:24PM +0000, Winkler, Tomas wrote:
> 
> > 
> > I'm tired of seeing Documentation/misc-devices/mei/mei-amt-version show
> > up in 'git status' as an untracked file, care to please fix it up?
> 
> Oh right I forgot the .gitignore
> 
> Maybe we can add some CONFIG_ option to avoid unconditional  compilation 
> of the example code, what do you think? 

Yes, that might be good.

> > But really, shouldn't binary files like this to into tools/ instead of
> > Documentation?
> I'm not sure it is really a tool it just really  example code.
> 
> There are other  examples of that e.g.  Documentation/watchdog/src/watchdog-test  and some more

tools/ is newer than those files, and how are they generated, by CONFIG
options, or something else?

thanks,

greg k-h
