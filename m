Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2KVUx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:53:28 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:60998 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab2KVUx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:53:26 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApdgANGPrlBV5h1yPGdsb2JhbABEhT0jhQC3CBcDAQEBAR8ZDSeCHgEBBAE6HCMFCwgDRhQlChqIGgrADxSQE2EDlgCFe404
X-IronPort-AV: E=Sophos;i="4.83,303,1352070000"; 
   d="scan'208";a="454350438"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 22 Nov 2012 21:53:52 +0100
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Henrik Rydberg <rydberg@bitmath.se>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 3.7-rc6
Message-ID: <20121122205352.GA500@polaris.bitmath.org>
References: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com>
 <20121120103905.GA3908@polaris.bitmath.org>
 <CAKMK7uEemJg=h3aY2xfTRaEqC9t5ADgS2-FSasAvdC66zbz1Vw@mail.gmail.com>
 <20121122111825.GA7188@polaris.bitmath.org>
 <CAKMK7uFr8jHALagnzJp26Sn-WMuj4VcMF0e+q0GKgyRbW0h-wg@mail.gmail.com>
 <20121122182325.GA777@polaris.bitmath.org>
 <CAKMK7uH1=vA7YCh9eZSyW=ewF3kYkdgT45LhYqnigPg0whe5aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uH1=vA7YCh9eZSyW=ewF3kYkdgT45LhYqnigPg0whe5aA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, the utter lack of a vbt fits very nicely, thanks for checking,
> I've merged the patch into drm-intel-fixes and will forward it for
> inclusion into 3.7 rsn.

Great, thanks. One thing about that patch: if we would ever encounter
a non-zero edp.bpp < 3, display_bpc would not be clamped. I suppose
monochrome screens went out of fashion twenty years ago, but who
knows...

Thanks,
Henrik
