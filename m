Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0JFHF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:05:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:19201 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab0JFHFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:05:55 -0400
Date: Wed, 6 Oct 2010 09:05:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree 
 (jdelvare-hwmon tree related)
Message-ID: <20101006090539.6dacba1e@endymion.delvare>
In-Reply-To: <20101006152831.f91a5610.sfr@canb.auug.org.au>
References: <20101006152831.f91a5610.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 6 Oct 2010 15:28:31 +1100, Stephen Rothwell wrote:
> Hi ,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/hwmon/pcf8591.c: In function 'pcf8591_probe':
> drivers/hwmon/pcf8591.c:205: error: implicit declaration of function 'IS_ERR'
> drivers/hwmon/pcf8591.c:206: error: implicit declaration of function 'PTR_ERR'
> 
> Caused by commit 63575f5628b811d80f81158825dbc9d3db4ac1a5 ("hwmon:
> (pcf8591) Register as a hwmon device").

Oh, right. Missing include, thanks for the heads up.

> See Rule 1 in Documentation/SubmitChecklist.

True, shame on me :(

> I have added reverted that commit (and
> 3eabb87a17ff8da477f7bf4c5a14063b68937fb1 ("hwmon: (pcf8591) Don't attempt
> to detect devices") that followed it) for today.

Fixed by now.

-- 
Jean Delvare
