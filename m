Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2KOJCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:02:43 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61234 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2KOJCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:02:39 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v3 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and custom getreg and setreg functions
References: <1352834727-16368-1-git-send-email-andreas@gaisler.com>
	<1352834727-16368-3-git-send-email-andreas@gaisler.com>
	<87sj8d86lo.fsf@dell.be.48ers.dk> <50A4A9A9.5050903@gaisler.com>
Date: Thu, 15 Nov 2012 10:02:35 +0100
In-Reply-To: <50A4A9A9.5050903@gaisler.com> (Andreas Larsson's message of
	"Thu, 15 Nov 2012 09:36:57 +0100")
Message-ID: <877gpn6xxw.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:

Hi,

 >> Adding a type define (TYPE_OCORES / TYPE_GRLIB) and a 2nd
 >> of_device_id entry with .data = TYPE_GRLIB, and then using that in
 >> the probe routine would be nicer. Have a look at i2c-at91.c for an
 >> example of a driver doing something like that.

 Andreas> Yes, that is a good idea. Do you think casting to and from
 Andreas> void * in the following solution is too ugly and rather have a
 Andreas> struct pointed to, or do you think that would be unnecessary?

I find the casting OK.

Thanks.

-- 
Bye, Peter Korsgaard
