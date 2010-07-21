Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab0GUXQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:16:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51782 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0GUXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:16:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MQZ3xCHuqUsxAKt27TNjFBT28iRpS88kGb55LBNxrJMWNlSI97u1eyrIuT/aNKEKYM
         rqF08aLyMTa9oiN00WJY6N5d0t+W8QKskvA613K0zeIFJeShQndyn/5GdPaAQcBczd3A
         +doXNvNoq0LlU1rI9uuuW5rgDgwrkyErUSsuM=
Date: Thu, 22 Jul 2010 01:16:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 1/6] ia64/perfmon: convert to unlocked_ioctl
Message-ID: <20100721231640.GA5801@nowhere>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278195310-25590-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 12:15:05AM +0200, Arnd Bergmann wrote:
> The ioctl function in this driver does not
> do anything that requires the BKL, so make
> it use unlocked_ioctl.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: linux-ia64@vger.kernel.org
> ---


Applied, thanks!

