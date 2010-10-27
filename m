Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0J0Rdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:33:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52516 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751881Ab0J0Rde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:33:34 -0400
Date: Wed, 27 Oct 2010 10:33:41 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>, lrg@slimlogic.co.uk,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
Message-ID: <20101027173340.GA25134@opensource.wolfsonmicro.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <AANLkTinc50bzQawaoA_XfkLhJXjVjPWzxgbCJ40UnYwi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinc50bzQawaoA_XfkLhJXjVjPWzxgbCJ40UnYwi@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 02:25:44PM -0200, Thiago Farina wrote:

> Shouldn't be this returning 1 instead of true and 0 instead false
> (since the return type is int not bool)?

There is no reason to do this, logical values are treated as 0 and 1 in
C.  Using false and true is clear and won't cause any difference in
code.

> Maybe like this?
> return (ret & info->mask) ? 1: 0;

No, that's needlessly obfuscated.
