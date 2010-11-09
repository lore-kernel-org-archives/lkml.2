Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0KIENv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:13:51 -0500
Received: from kroah.org ([198.145.64.141]:58865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0KIENu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:13:50 -0500
Date: Mon, 8 Nov 2010 19:24:55 -0800
From: Greg KH <greg@kroah.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: devel <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: brcm80211 unable to survive suspend/resume cycle
Message-ID: <20101109032455.GA31048@kroah.com>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:13:57PM -0500, Jon Masters wrote:
> Folks,
> 
> I reported this before, but let me open up a new thread for this now
> that this driver has landed in 2.6.37-rc1 and been out for a while. I am
> able to use this driver (more or less) for daily use on my netbook, but
> it is unable survive a suspend/resume cycle without being unloaded and
> then reloaded again on resume. That actually seems to work quite well.
> 
> I believe the problem is firmware related:

<snip>

Did you copy the authors/developers on this bug report?

Please do that...
