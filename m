Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AYTzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:55:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1AYTzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:55:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Tue, 25 Jan 2011 20:54:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101252038.25113.rjw@sisk.pl> <4D3F2869.3000406@pardus.org.tr>
In-Reply-To: <4D3F2869.3000406@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101252054.46647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 25, 2011, Ozan Çağlayan wrote:
> On 25.01.2011 21:38, Rafael J. Wysocki wrote:
> 
> > Does
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ec30f343d61391ab23705e50a525da1d55395780
> > generally help?
> 
> Well I can let them try a patched kernel but will a kernel showing 
> acpi_idle as the cpuidle driver in dmesg will be affected by this patch?
> I can't see any sign on reporters' dmesg that intel_idle is active.

If intel_idle is not active, then the patch will not help.

However, it would be good to check if the affected systems work with
intel_idle + the above patch instead of acpi_idle.

Thanks,
Rafael
