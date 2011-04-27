Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1D0UVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:21:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1036 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab1D0UVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:21:03 -0400
Subject: Re: [PATCH v3.2] kbuild: implement several W= levels
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <1303935327-5154-1-git-send-email-bp@alien8.de>
References: <20110427113513.GB18112@eferding.osrc.amd.com>
	 <1303935327-5154-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 13:21:00 -0700
Message-ID: <1303935660.24299.76.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 22:15 +0200, Borislav Petkov wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
[]
> +warning-1 += -Wold-style-definition
> +warning-1 += $(call cc-option, -Wmissing-include-dirs)

Only thing I would suggest is a comment describing why
some entries use $(call cc-option, -Wfoo) and others don't.

Something akin to:

# Use call cc-option when the minimum supported gcc version does not
# support a specific option but a later gcc version does.



