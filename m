Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1FONuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:50:15 -0400
Received: from support.opsdc.com ([65.254.219.9]:40806 "EHLO support.opsdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1FONuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:50:13 -0400
Subject: Re: Panic on OOM
From: Chris Fowler <cfowler@outpostsentinel.com>
Reply-To: cfowler@opsdc.com
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1106141947570.8257@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com>
	 <1308103443.2074.357.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141908100.7025@chino.kir.corp.google.com>
	 <1308105693.2074.361.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141947570.8257@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jun 2011 09:50:05 -0400
Message-ID: <1308145805.2074.367.camel@compaq-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 19:51 -0700, David Rientjes wrote:
> I was attempting to diagnose an issue where the machine failed to
> actually reboot after the "Rebooting in 10 seconds..." message.  So
> the issue is that the machine becomes unresponsive for an indefinite
> period of time between invoking your perl script and seeing the panic,
> or that the machine fails to reboot after "Rebooting in 10
> seconds..."? 

It has been almost 12 hours and no panic yet.  Externally the box seems
unresponsive.  No response to network activity.  No keyboard response,
etc.  On the screen I'm still seeing printk's from the hda-intel driver
complaining about a spurious interrupt.  I'm not to concerned about that
but it does tell me the kernel seems to be alive.

Chris


