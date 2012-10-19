Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2JSRA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:00:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37421 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2JSRA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:00:57 -0400
Date: Fri, 19 Oct 2012 10:00:49 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: joseph.salisbury@canonical.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        perex@perex.cz, tiwai@suse.de, david.henningsson@canonical.com,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/1] ALSA: hda - add quirk for Thinkpad T430
Message-ID: <20121019170049.GA4787@elie.Belkin>
References: <cover.1350570761.git.joseph.salisbury@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1350570761.git.joseph.salisbury@canonical.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

joseph.salisbury@canonical.com wrote:

> [Subject: [PATCH 0/1] ALSA: hda - add quirk for Thinkpad T430]]
[...]
> This patch is to enable audio on T430 Thinkpads.  There is no audo
> from the headphone jack without this patch.  This patch adds a quirk
> for the T430 model.  

Please don't do this cover-letter thing.  A cover letter can be a
good way to *summarize* a long patch series so readers are less
daunted, but any information that was needed to know in order to
evaluate a patch, briefly stated, should be in the commit message that
actually gets committed.

Thanks and hope that helps,
Jonathan
