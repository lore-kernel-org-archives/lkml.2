Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab0EFQ5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab0EFQ5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:57:04 -0400
Date: Thu, 6 May 2010 18:56:10 +0200
From: Jerome Glisse <jglisse@redhat.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.freedesktop.org
Subject: Re: linux-next - drm/ttm versus nouveau - WARNING and dead driver.
Message-ID: <20100506165610.GB8934@barney.localdomain>
References: <7841.1273161966@localhost>
 <j2gb170af451005060916of64cbd20x12ea697de19931b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <j2gb170af451005060916of64cbd20x12ea697de19931b2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 06:16:26PM +0200, Rafał Miłecki wrote:
> 2010/5/6  <Valdis.Kletnieks@vt.edu>:
> > Bisected down to:
> >
> > 82c5da6bf8b55a931b042fb531083863d26c8020 is the first bad commit
> > commit 82c5da6bf8b55a931b042fb531083863d26c8020
> > Author: Jerome Glisse <jglisse@redhat.com>
> > Date:   Fri Apr 9 14:39:23 2010 +0200
> >
> >    drm/ttm: ttm_fault callback to allow driver to handle bo placement V6
> 
> Can this be duplicate of https://bugs.freedesktop.org/show_bug.cgi?id=27822 ?
> 
> -- 
> Rafał

Yes this is a duplicate of :
https://bugs.freedesktop.org/show_bug.cgi?id=27822

The patch attached in the bug should fix your issue. Sorry for the
trouble.

Cheers,
Jerome
