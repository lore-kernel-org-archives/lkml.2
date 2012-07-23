Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2GWNoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:44:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2GWNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:44:32 -0400
Date: Mon, 23 Jul 2012 08:44:27 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apple-gmux: Fix kconfig dependencies
Message-ID: <20120723134427.GA3524@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org,
	Arun Raghavan <arun.raghavan@collabora.co.uk>,
	linux-kernel@vger.kernel.org
References: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com>
 <20120716235034.GB11710@ubuntu-530U>
 <20120723133010.GE21495@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723133010.GE21495@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 02:30:10PM +0100, Matthew Garrett wrote:
> > I'm looking at Andreas's code for switcharoo support, and something I
> > want to do along with it is make apple-gmux not dependent on backlight
> > support (i.e. you can still build switcharoo support if
> > BACKLIGHT_CLASS_DEVICE is disabled). I'm assuming this patch as a
> > prerequisite. But things do get really monstrously ugly, so if there's a
> > cleaner way to enforce this that I haven't found I'd love to hear about
> > it.
> 
> Why do you want to support that case? One of the problems we have with 
> the kernel at present is that it's trivial to come up with non-sensical 
> configurations. I can't think of a single case where you'd want the gmux 
> support without also having the backlight support code.

Just because there isn't strictly any reason that the switching code
needs to depend on backlight support. But yes, I can't think of a good
reason why anyone would want this configuration. I won't mess with it
then.

Seth

