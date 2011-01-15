Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1AOVy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 16:54:58 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:51057 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1AOVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 16:54:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IWd8qepaYSXdh5NaOYFZSaRQ5B6H7klIf4WDloFhwB/+8KttHohTNC1I4j5yvs/MBR
         rpM+mtw7O1gUr1d/DWD3tiYcKhaqsXc+GZ50jd2L+DoUPKN1yOYrxq9+9ju4S3uCQpxI
         TrgKHYnFS6hbUqH5fwIovmRAm7xejMgsROKDc=
Date: Sat, 15 Jan 2011 13:54:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-input@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] sysrq is half-enabled by default
Message-ID: <20110115215450.GB19872@core.coreip.homeip.net>
References: <1295123037-2649-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295123037-2649-1-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Sat, Jan 15, 2011 at 08:23:56PM +0000, Andy Whitcroft wrote:
> It seems that recent cleanups to sysrq handling have lead to us having
> two copies of the sysrq enable status.  At boot these are currently
> inconsistently specified leading to sysrq actually being enabled but
> reported as not enabled in sysfs.  Following this email is a patch to
> link both of these copies to a common configuration setting.
> 

Thanks for noticing this, but I do not think we need a new configuration
parameter. We did not have it for about 10 years and distributions know
how to disable it upon boot if they want to.

Do youthink you could cange the patch and add a default value (1) to
inlude/linux/sysrq.h and use it in sysctl and the handler code?

Thanks!

-- 
Dmitry
