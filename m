Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1IUMxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:53:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1IUMw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:52:58 -0400
Date: Wed, 21 Sep 2011 07:52:52 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>, Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] toshiba_acpi: Convert to use acpi_driver
Message-ID: <20110921125252.GA23254@thinkpad-t410>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Matthew Garrett <mjg@redhat.com>,
	Azael Avalos <coproscefalo@gmail.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
 <1316555754-25949-2-git-send-email-seth.forshee@canonical.com>
 <1316557078.1903.11.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316557078.1903.11.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:17:57PM -0700, Joe Perches wrote:
> On Tue, 2011-09-20 at 16:55 -0500, Seth Forshee wrote:
> > Changes toshiba_acpi to register an acpi driver and eliminates the
> > platform device it was using.
> 
> Just trivial comments...

Thanks for the suggestions. Since all those are existing code rather
than new code, I'll incorporate them if I have to respin the patches
(aside from the static problems that Corentin pointed out), otherwise
they can be done in a follow-on patch.
