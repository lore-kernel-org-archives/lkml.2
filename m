Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0C0X3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:29:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58237 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab0C0X3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:29:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH/RFC] platform_bus: Allow runtime PM by default
Date: Sun, 28 Mar 2010 00:32:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201003262335.06941.rjw@sisk.pl> <251AAFA3-F44D-40D2-BF99-E82EE58FD52D@opensource.wolfsonmicro.com>
In-Reply-To: <251AAFA3-F44D-40D2-BF99-E82EE58FD52D@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003280032.01011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 March 2010, Mark Brown wrote:
> On 26 Mar 2010, at 22:35, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Friday 26 March 2010, Mark Brown wrote:
> >> Currently the default runtime PM callbacks for platform devices  
> >> return
> >> -ENOSYS, preventing the use of runtime PM platforms until they have
> >> provided at least a default implementation. This hinders the use of
> >> runtime PM by devices which work with many platforms such as memory
> >> mapped devices, MFDs and on chip IPs shared by multiple  
> >> architectures.
> >>
> >> Change the default implementation to the standard pm_generic_runtime
> >> one, allowing drivers to use runtime PM without per-architecture
> >> changes.
> >>
> >> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Is it very urgent?
> 
> Not especially - worst case you just don't get devices suspending  
> which isn't the end of the world and there's no build time  
> dependencies introduced.

OK, so I guess it will be sufficient if Greg queues it for .35.

Rafael
