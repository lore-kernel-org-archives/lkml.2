Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0JaKGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 06:06:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:26786 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab0JaKGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 06:06:13 -0400
Date: Sun, 31 Oct 2010 11:05:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Joe Perches <joe@perches.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 0/8] hwmon: applesmc: Dynamic configuration rewrite
Message-ID: <20101031110553.5744668a@endymion.delvare>
In-Reply-To: <4CCD2C7A.6020703@euromail.se>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
	<1288513860.366.205.camel@Joe-Laptop>
	<4CCD2C7A.6020703@euromail.se>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010 09:44:42 +0100, Henrik Rydberg wrote:
> On 10/31/2010 09:31 AM, Joe Perches wrote:
> 
> > On Sun, 2010-10-31 at 08:50 +0100, Henrik Rydberg wrote:
> >> This patchset introduces dynamic configuration by making the SMC
> >> register set efficiently searchable, and fixes a number of outstanding
> >> issues:
> > 
> > Hi Henrik.
> > 
> > Your patches are built on top of a patch I submitted
> > that wasn't accepted by Jean or Guenter.
> 
> 
> Right. I imagine there will be new revisions of that patch. If we are all
> targeting 2.6.38, I can certainly rebase this set back to the current head, if
> that is preferrable. Jean?

Hendrik, Joe, please give me a few days to finish urgent pending work,
and I'll get back to you regarding both issues. I'm sure we can sort it
all out :)


-- 
Jean Delvare
