Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab1DSQbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:31:45 -0400
Received: from mail.perches.com ([173.55.12.10]:4842 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1DSQbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:31:44 -0400
Subject: Re: [PATCH 2/2] drm: Verify debug message arguments
From: Joe Perches <joe@perches.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ian Romanick <idr@freedesktop.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <20110419162604.GA2861@joi.lan>
References: <cover.1303097621.git.joe@perches.com>
	 <c24620769d5864c0c0e460358b256acd0ada5c79.1303097621.git.joe@perches.com>
	 <4DACC2B9.3020200@freedesktop.org> <1303168151.31723.50.camel@Joe-Laptop>
	 <20110419162604.GA2861@joi.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 09:31:43 -0700
Message-ID: <1303230703.31723.73.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 18:26 +0200, Marcin Slusarz wrote:
> On Mon, Apr 18, 2011 at 04:09:11PM -0700, Joe Perches wrote:
> > On Mon, 2011-04-18 at 16:01 -0700, Ian Romanick wrote:
> > > > -		DRM_DEBUG_KMS("LVDS downclock is found in VBT. ",
> > > > -				"Normal Clock %dKHz, downclock %dKHz\n",
> > > > -				temp_downclock, panel_fixed_mode->clock);
> > > > +		DRM_DEBUG_KMS("LVDS downclock is found in VBT. "
> > > > +			      "Normal Clock %dKHz, downclock %dKHz\n",
> > > > +			      temp_downclock, panel_fixed_mode->clock);
> > > Does this hunk only change white space, or am I missing something?
> > No, you're right.  It's just whitespace.
> > I prefer arguments aligned to open paren.
> It's not just whitespace. Look at the end of first line.

Heh.  Thanks Marcin.

Teach me to just at the code in the patch.

It's a format error as the first quoted string has
a comma at the end so the arguments after the comma
were ignored.


