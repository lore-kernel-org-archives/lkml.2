Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab0FDSCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:02:39 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:40808 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751265Ab0FDSCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:02:38 -0400
Date: Fri, 4 Jun 2010 14:02:25 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Commit 9b8c4a0b215e603497daebe8ecbc9b1f0f035808 broken X11
 pointer
Message-ID: <20100604180225.GA2439@elliptictech.com>
Mail-Followup-To: Jeff Chua <jeff.chua.linux@gmail.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Eric Anholt <eric@anholt.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.1006041547530.2447@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006041547530.2447@boston.corp.fedex.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:53 Fri 04 Jun     , Jeff Chua wrote:
> The following commit broke X11 mouse pointer. Symptom is "mouse pointer" 
> on X11 cannot change "shape" when positioned to the frames of xterm 
> window.
> 
> Reverting it makes it work again.
> 
> commit 9b8c4a0b215e603497daebe8ecbc9b1f0f035808

Should be fixed by the patch attached to this bug:

  https://bugs.freedesktop.org/show_bug.cgi?id=28335

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
