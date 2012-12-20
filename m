Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2LTTUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:20:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40912 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab2LTTUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:20:35 -0500
Date: Thu, 20 Dec 2012 20:20:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
Message-ID: <20121220192033.GG26635@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Jacob Shin <jacob.shin@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355864771-13839-1-git-send-email-jacob.shin@amd.com>
 <1355864771-13839-3-git-send-email-jacob.shin@amd.com>
 <1355868659.3982.3.camel@joe-AO722>
 <20121218225610.GL31255@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121218225610.GL31255@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:56:10PM +0100, Borislav Petkov wrote:
> So, if you'd like, you could wait until I apply Jacob's patches and
> push that git branch to kernel.org and then write a patch ontop
> removing all the exports except pp_msgs (you could add them to the
> "amd_" namespace by calling it amd_pp_msgs or something) test that
> patch and send it to me.

Ok, I've applied Jacob's stuff. You can do your patch ontop of

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git edac-for-3.9

and send it to me.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
