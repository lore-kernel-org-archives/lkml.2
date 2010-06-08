Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab0FHUvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:51:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39450 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab0FHUvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:51:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Regression: BUG when battery is removed before resuming from hibernation
Date: Tue, 8 Jun 2010 22:52:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4C0E40E1.2080108@tuffmail.co.uk>
In-Reply-To: <4C0E40E1.2080108@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006082252.49452.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 June 2010, Alan Jenkins wrote:
> I found this bug 2.6.34 on my Asus EeePC 701 (x86_32 arch).  It didn't 
> happen to me before, when I was running nearly-2.6.33 or 2.6.32-release.
> 
> I used git-bisect, but unfortunately the result isn't very helpful.  My 
> next step will be to try to narrowing down the culprits by disabling 
> individual CONFIG options.  Here are my results so far, in case anyone 
> is interested.
> 
> 
> == Steps to reproduce ==
> 
> I) Boot off mains power, with battery removed.  Login to KDE4 session, 
> with Konsole as the only running application.
> II) Run "sudo pm-hibernate"
> 
> 1. When the system switches to text mode (a.k.a the console), 
> immediately insert the battery.
> 2. Once the system has fully hibernated, remove the battery.
> 3. Press the power button to resume.  The backtrace below is generated 
> during resume.

You're not supposed to be doing that.

Rafael
