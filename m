Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1EJAVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 20:21:12 -0400
Received: from kroah.org ([198.145.64.141]:59931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab1EJAVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 20:21:11 -0400
Date: Mon, 9 May 2011 17:18:53 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 077/206] Staging: hv: Get rid of call to cleanup()
Message-ID: <20110510001853.GA7041@kroah.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-77-git-send-email-kys@microsoft.com>
 <20110509225328.GA2832@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481EEBA7@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481EEBA7@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 11:53:35PM +0000, KY Srinivasan wrote:
> > Note, I wouldn't recommend sending that many patches to lkml, it's not
> > needed, just stick to the devel@linuxdriverproject.org list as I really
> > doubt anyone else cares about this code at the moment.
> 
> Agreed; I will do that. Shall I go ahead and fix the names and send the patches 
> just to you or do you want me to send them to the devel list as well.

As they have all failed to show up to the list, it can't hurt to send
them all again there as well as to me.

thanks,

greg k-h
