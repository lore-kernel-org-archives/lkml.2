Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2KNSEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:04:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51198 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2KNSEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:04:11 -0500
Date: Wed, 14 Nov 2012 10:04:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [RFC] staging: ste_rmi4: merge into the main kernel tree
Message-ID: <20121114180401.GC29131@core.coreip.homeip.net>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121113201212.8550fb074e1f7cce78f29d97@tw.synaptics.com>
 <20121113175309.GA3601@polaris.bitmath.org>
 <CC51EC7B5B7F984AA566DC102237848896F62894@hkdcw-mail1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F62894@hkdcw-mail1.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

On Wed, Nov 14, 2012 at 05:40:12PM +0000, Alexandra Chin wrote:
> Hi Henrik and all,
> 
> As I know, currently there is no synaptics RMI4 touchscreen driver in the
> main tree. In order to support our customers effectively, is it able to merge
> staging ste_rmi4 driver into the main kernel.org tree? If it is accepted, should
> I send a patch for this change?

I believe that we should keep ste_rmi4 in staging, not as reflection of
its code quality, but rather because it is a temporary solution until
full-fledged RMI4 driver is merged.

Please have Greg commit the patch that Henrik reviewed to staging and
then work with Christopher Heiny group on getting the full featured
driver into mainline.

Thanks.

-- 
Dmitry
