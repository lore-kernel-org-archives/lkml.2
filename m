Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1EYTE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:04:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33254 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064Ab1EYTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:04:27 -0400
X-Sasl-enc: xghCKsVD63TbaZPzXwGoCiApMxT/SJ8hGWWslxKyYKtm 1306350267
Date: Wed, 25 May 2011 16:04:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525190424.GA17793@khazad-dum.debian.net>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525070604.GE429@elte.hu>
 <20110525160656.GB25225@khazad-dum.debian.net>
 <20110525165803.GB14958@tassilo.jf.intel.com>
 <20110525182405.GA17864@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525182405.GA17864@elte.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Ingo Molnar wrote:
> So displaying a non-fatal 'info' message about it would in fact be 
> rather wise. Nothing scary, but we'd like to be informed.

A printk with levels info or notice, I do agree to be a good idea.  In fact,
I like the idea a lot.

WARN() and kernel tainting, which is what I understand was being proposed
before, I cannot agree with.

OTOH, IMO mismatched microcode should be grounds for more serious measures.
And that includes fixing the annoying userspace ABI that encourages bad
behaviour in the first place and makes it harder to do the proper thing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
