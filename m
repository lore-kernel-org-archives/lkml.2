Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2DVQmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:42:52 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:7023 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752234Ab2DVQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:42:51 -0400
Date: Sun, 22 Apr 2012 12:42:49 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120422164248.GB32342@elliptictech.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
 <20120422040715.GA30689@elliptictech.com>
 <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
 <CAPM=9tx9=mCEv-K8y95O-L6+8vWk4gt42ncFyNivV1S8T-9ykA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tx9=mCEv-K8y95O-L6+8vWk4gt42ncFyNivV1S8T-9ykA@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-22 08:26 +0100, Dave Airlie wrote:
> I've been asking Ben about this, I might have to use a bit more pressure,
> 
> It would be worth bisecting drivers/gpu/drm only, I doubt its going to
> be outside that area.

Since the original bisection was restricted to drivers/gpu, and there
appears to be exactly 0 commits between v3.2 and v3.3 that touch files
in drivers/gpu outside of drivers/gpu/drm, I think this should make no
difference?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

