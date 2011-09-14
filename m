Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1INHms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:42:48 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:41010 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1INHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:42:47 -0400
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlxSADBacE5V5qg/Omdsb2JhbABBp3cLAQEBASEWM4FTAQEEATocIxAIA0YUJQoaiAoCArUqDoYAYASYaIt+
X-IronPort-AV: E=Sophos;i="4.68,379,1312149600"; 
   d="scan'208";a="1759234736"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 14 Sep 2011 09:46:21 +0200
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
Message-ID: <20110914074621.GA3582@polaris.bitmath.org>
References: <1315029042-27513-1-git-send-email-martinez.javier@gmail.com>
 <1315029042-27513-2-git-send-email-martinez.javier@gmail.com>
 <20110913082448.GA5046@polaris.bitmath.org>
 <CAAwP0s0FvkzTUo5kAZE_pd_8u-znDvoLks74gf8+75cUF0aM2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAwP0s0FvkzTUo5kAZE_pd_8u-znDvoLks74gf8+75cUF0aM2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Compared to the staging version you sent earlier, this version seems
> > to be a step back towards the original version regarding the MT
> > implementation. Is this the right patch?
> 
> Hello Henrik,
> 
> Yes it is the right patch, or at least the patch I meant to send. The
> staging version I send earlier didn't support multi-touch protocol
> type A.

I see - the cyttsp_xydata struct seems to be the old version,
though. Any particular reason for that? Also, the similarity to the
problem found here, https://lkml.org/lkml/2011/8/25/516, suggests your
16 tracking ids could be mapped directly to slots instead, using the
example code. It ought to reduce the present patch significantly.

Thanks,
Henrik
