Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1GXWdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:33:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46067 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1GXWdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:33:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-2?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400
Date: Mon, 25 Jul 2011 00:34:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org
References: <201107232127.34255.toralf.foerster@gmx.de> <201107242323.54819.rjw@sisk.pl> <201107242349.08560.toralf.foerster@gmx.de>
In-Reply-To: <201107242349.08560.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107250034.33633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 24, 2011, Toralf Förster wrote:
> 
> Rafael J. Wysocki wrote at 23:23:54
> > So the failure happens only if the machine is in the dock?
> 
> No - if the machine was booted (or rebooted) while docked and later was 
> s2ramed (even if the machine was undocked before) - then the kernel crashed 
> (and can only be avoided by unloading the module iwlagn before).

That's strange.  It seems that the wireless adapter depends on something
in the dock on your system.

Please attach dmesg after booting in the dock and outside of it.

Thanks,
Rafael
