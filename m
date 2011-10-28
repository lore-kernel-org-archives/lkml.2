Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab1J1Qko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 12:40:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab1J1Qkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 12:40:43 -0400
Date: Fri, 28 Oct 2011 18:27:59 +0200
From: Greg KH <gregkh@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Miche Baker-Harvey <miche@google.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Amit Shah <amit.shah@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] VirtioConsole support.
Message-ID: <20111028162759.GA27263@suse.de>
References: <20111027173527.GA23839@phenom.dumpdata.com>
 <1319751802-27013-1-git-send-email-miche@google.com>
 <20111027215535.GA5671@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027215535.GA5671@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 05:55:35PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 27, 2011 at 02:43:22PM -0700, Miche Baker-Harvey wrote:
> > Multiple HVC console terminals enabled.
> 
> Miche,
> 
> You might want to flesh out the description a bit. Perhaps include
> such details as : "fixes the infinite loop that git commit XX
> caused". Perhaps include some of the serial console output.
> 
> Maybe also change the title - the patch name (which is what shows up
> if you do 'git log --oneline') is 'VirtioConsole support.' which is
> not very informative.

Yes, all of these need to be resolved before I can accept this.

thanks,

greg k-h
