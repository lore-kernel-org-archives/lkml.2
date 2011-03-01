Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab1CAXad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:30:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab1CAXac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:30:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: 2.6.38 regression caused by commit 415e12b
Date: Wed, 2 Mar 2011 00:30:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
References: <20110228014218.GA11083@xanatos> <201103012155.34182.rjw@sisk.pl> <20110301225058.GA2294@xanatos>
In-Reply-To: <20110301225058.GA2294@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103020030.16494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 01, 2011, Sarah Sharp wrote:
> On Tue, Mar 01, 2011 at 09:55:33PM +0100, Rafael J. Wysocki wrote:
> > Please check if the appended patch (on top of the Linus' current) helps.
> 
> Sorry, it doesn't help.  Same message as before.

Can you send dmesg with the patch applied, please?

Rafael
