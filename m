Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2ANRpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 12:45:04 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:34686 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab2ANRpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 12:45:03 -0500
Date: Sat, 14 Jan 2012 18:44:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Alex Rio <scasbyte@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] hwmon: (w83627ehf) Replace deprecated 
 strict_strto*
Message-ID: <20120114184445.3871e019@endymion.delvare>
In-Reply-To: <20120114172538.GD29012@ericsson.com>
References: <CAPbJ=B=Z=FRiuR0Cb5uQhtNxWoARr59iFocnd0VRzNfSKXLp_w@mail.gmail.com>
	<20120114172538.GD29012@ericsson.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012 09:25:38 -0800, Guenter Roeck wrote:
> On Fri, Jan 13, 2012 at 08:39:41PM -0500, Alex Rio wrote:
> > Replaces deprecated function strict_strto* to kstrto*. In the future
> > the strict_strto could disappear so the replacement was done.
> > I'm not sure if this is being done for all the files in a single
> > patch, anyway I'm including it here just in case.
> > Checkpatch.pl now leaves 5 "errors", they are mostly
> > assignments inside if's statements, taking them out does not
> > significantly increases readability.
> > 
> > Signed-off-by: Alex Rio <scasbyte@gmail.com>
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> Jean, do you want to take this one ? Otherwise, I'll add it to my pending list
> for the next -rc.

Err, I'm confused... Aren't these changes already upstream?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=drivers/hwmon/w83627ehf.c;h=0e0af0445222c4346af8fef879831831e49caffa;hp=93f5fc7d60596c3ab27c23c5794fccd4a53a40a5;hb=179c4fdb565dd2157e5dfe89318b74868e3b523d;hpb=24edc0a71badc13a9574b060e6a22e78339ac7a4

-- 
Jean Delvare
