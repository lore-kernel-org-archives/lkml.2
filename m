Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2APXn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:43:27 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31513 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2APXn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:43:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6591"; a="155485224"
From: Martin Fick <mfick@codeaurora.org>
Organization: CAF
To: Junio C Hamano <junio@pobox.com>
Subject: Re: Re* Regulator updates for 3.3
Date: Mon, 16 Jan 2012 16:43:22 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.32-28-generic; KDE/4.4.5; x86_64; ; )
Cc: Pete Harlan <pgit@pcharlan.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com> <4F136BE4.4040502@pcharlan.com> <7v62gbussz.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7v62gbussz.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161643.23211.mfick@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 16, 2012 04:33:00 pm Junio C Hamano 
wrote:
> With your suggestion, they need to export
> "GIT_MERGE_EDIT=0" today, and they will need to update
> again to export "GIT_MERGE_SOMETHINGELSE=0" when such an
> incompatible change comes.
> 
> With a single "GIT_MERGE_LEGACY=YesPlease", they can be
> future-proofed today and will not be affected when we
> make another incompatible change.
> 
> So I am not sure why separating the big-red-switch into
> smaller pieces would be an improvement, especially wnen
> the scripts that want to specify finer-grained control
> of features can use "--[no-]edit" options to explicitly
> ask for it.


Then, what would I do if I write a script which uses the new 
edit functionality (without even being aware that there was 
an old way) and you introduce a new incompatibility?  I 
can't turn on GIT_MERGE_LEGACY then since it would revert to 
behavior which my script would not expect (since it was 
written after the current incompatibility, but before the 
new one)!

-Martin
