Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1AZRDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:03:41 -0500
Received: from skl2.ukl.uni-freiburg.de ([193.196.199.2]:57550 "EHLO
	relay2.uniklinik-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab1AZRDj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:03:39 -0500
Subject: Re: Linux 2.6.37 x86 ncpfs regression: kernel BUG at
 include/linux/dcache.h:340 with >1366 files in directory
From: "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110126163203.GP22723@ZenIV.linux.org.uk>
References: <1296053700.2684.19.camel@pst15.ukl.uni-freiburg.de>
	 <20110126163203.GP22723@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 18:03:32 +0100
Message-ID: <1296061412.2684.59.camel@pst15.ukl.uni-freiburg.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
X-NAI-Spam-Flag: NO
X-NAI-Spam-Level: *
X-NAI-Spam-Threshold: 5
X-NAI-Spam-Score: 1.2
X-NAI-Spam-Report: 3 Rules triggered
	*  1 -- FROM_ALIAS_QUOTES_EVOL_2
	*  0.2 -- RCVD_FROM_BY_ENVFRM_1_AT_2
	*  0 -- RV3749
X-NAI-Spam-Version: 2.2.0.9286 : core <3749> : streams <589557> : uri
 <788203>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

thanks for the response!

> Plain .37?  Not .38-rc1?

Yes. 2.6.37-gentoo to be exact. gentoo adds the fbcondecor patch.

> 3825bdb7ed920845961f32f364454bee5f469abb may be a suspect...

I checked that dcache.c change but 2.6.37 doesn't include that one.

Best regards,
Bernd

