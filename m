Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0JaIzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 04:55:38 -0400
Received: from mail.perches.com ([173.55.12.10]:3886 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab0JaIzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 04:55:35 -0400
Subject: Re: [PATCH 0/8] hwmon: applesmc: Dynamic configuration rewrite
From: Joe Perches <joe@perches.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
In-Reply-To: <4CCD2C7A.6020703@euromail.se>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
	 <1288513860.366.205.camel@Joe-Laptop>  <4CCD2C7A.6020703@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Oct 2010 01:55:33 -0700
Message-ID: <1288515333.366.209.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-31 at 09:44 +0100, Henrik Rydberg wrote:
> On 10/31/2010 09:31 AM, Joe Perches wrote:
> > On Sun, 2010-10-31 at 08:50 +0100, Henrik Rydberg wrote:
> >> This patchset introduces dynamic configuration by making the SMC
> >> register set efficiently searchable, and fixes a number of outstanding
> >> issues:
> > Your patches are built on top of a patch I submitted
> > that wasn't accepted by Jean or Guenter.
> Right. I imagine there will be new revisions of that patch.

Maybe, but probably not by me.

Jean and I have different opinions on how quickly
what he views as a necessary kernel-wide precursor
patch might be applied.


