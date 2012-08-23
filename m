Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab2HWNn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:43:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33240 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2HWNnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:43:53 -0400
Message-ID: <1345729603.1503.5.camel@localhost.localdomain>
Subject: Re: [REGRESSION] dell-laptop: Caused by "Remove rfkill code" commit
From: Sebastian Poehn <sebastian.poehn@googlemail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 23 Aug 2012 15:46:43 +0200
In-Reply-To: <20120823131458.GA18067@srcf.ucam.org>
References: <1345726401.1481.8.camel@localhost.localdomain>
	 <20120823131458.GA18067@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 14:14 +0100, Matthew Garrett wrote:
> On Thu, Aug 23, 2012 at 02:53:21PM +0200, Sebastian Pöhn wrote:
> 
> > As rfkill can not get the state of the physical kill-switch, both state may differ.
> 
> b43 should know the state of the physical rfkill switch even if there's 
> no platform code to support it.
> 
BCM 4313 is _only_ supported by BCMs proprietar driver and brcmsmac; and
the later one I use.

Further there should be problems with other Wifis, like Intel?


