Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1BCPy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:54:56 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:38032 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1BCPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:54:55 -0500
X-Greylist: delayed 45294 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 10:54:55 EST
Date: Thu, 3 Feb 2011 10:54:25 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Gergely Nagy <algernon@balabit.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110203155425.GA2270@elliptictech.com>
References: <1296733177.14846.26.camel@moria>
 <20110203153252.GA24153@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203153252.GA24153@mail.hallyn.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-03 15:32 +0000, Serge E. Hallyn wrote:
> At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> 0, refuse if cap_sys_admin, if 1, then allow.

This had better default to 1, since that's the "don't break working
systems" setting.  Users (more likely, distributions) can set it to 0
when they have new enough userspace.

> This will allow users to acknowledge (permanently, if they must, using
> /etc/sysctl.conf) that they've seen the syslog message about
> cap_sys_admin being deprecated for syslog.

Why should the user need to acknowledge anything in order for their
system to not be broken?  What are they supposed to do otherwise?

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
