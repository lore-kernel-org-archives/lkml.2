Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2BQT2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:28:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60644 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2BQT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:28:08 -0500
Date: Fri, 17 Feb 2012 20:28:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, vm-crosstalk@vmware.com, dtor@vmware.com,
        cschamp@vmware.com
Subject: Re: [PATCH 00/14] RFC: VMCI for Linux
Message-ID: <20120217192803.GD2707@elf.ucw.cz>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  drivers/misc/vmw_vmci/Kconfig               |   16 +
>  drivers/misc/vmw_vmci/Makefile              |   36 +
>  drivers/misc/vmw_vmci/driver.c              | 2352 +++++++++++++++++++++++
>  drivers/misc/vmw_vmci/vmciCommonInt.h       |  105 ++
>  drivers/misc/vmw_vmci/vmciContext.c         | 1763

CamelCase in both file names and file contents... please don't.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
