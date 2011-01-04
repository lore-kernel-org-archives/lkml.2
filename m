Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab1ADO47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:56:59 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:19202 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751176Ab1ADO46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:56:58 -0500
Date: Tue, 4 Jan 2011 15:56:56 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Update atime from future.
Message-ID: <20110104145656.GM21618@bitwizard.nl>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com> <20110103021708.d5abf7bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103021708.d5abf7bd.akpm@linux-foundation.org>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jan 03, 2011 at 02:17:08AM -0800, Andrew Morton wrote:
> On Wed, 29 Dec 2010 21:58:41 +0800 yangsheng <sickamd@gmail.com> wrote:
> > -	 * Is the previous atime value older than a day? If yes,
> > +	 * Is the previous atime value old than a day? If yes,

You introduced a typo. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
