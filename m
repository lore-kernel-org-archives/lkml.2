Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2JYK4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:56:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51649 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756422Ab2JYK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:56:23 -0400
Message-ID: <1351162563.5303.3.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v3] x86: efi: Turn off efi_enabled after setup on mixed
 fw/kernel
From: Matt Fleming <matt@console-pimps.org>
To: Olof Johansson <olof@lixom.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, marko.kohtala@gmail.com,
        Matthew Garrett <mjg@redhat.com>
Date: Thu, 25 Oct 2012 11:56:03 +0100
In-Reply-To: <1351098044-4586-1-git-send-email-olof@lixom.net>
References: <1351059878-28795-1-git-send-email-olof@lixom.net>
	 <1351098044-4586-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 10:00 -0700, Olof Johansson wrote:
> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
> efi_enabled once setup is done. Beyond setup, it is normally used to
> determine if runtime services are available and we will have none.
> 
> This will resolve issues stemming from efivars modprobe panicking on a
> 32/64-bit setup, as well as some reboot issues on similar setups.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45991
> 
> Reported-by: Marko Kohtala <marko.kohtala@gmail.com>
> Reported-by: Maxim Kammerer <mk@dee.su>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: stable@kernel.org # 3.4 - 3.6
> Cc: Matthew Garrett <mjg@redhat.com>

Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center

