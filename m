Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0EXV3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 17:29:30 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:62141 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab0EXV33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 17:29:29 -0400
MIME-Version: 1.0
X-Originating-IP: [66.187.234.200]
In-Reply-To: <tkrat.188ec405b9253375@s5r6.in-berlin.de>
References: <4BF93F10.5070903@s5r6.in-berlin.de>
	 <201005232348.o4NNm5kK024726@turbo.physics.adelaide.edu.au>
	 <tkrat.188ec405b9253375@s5r6.in-berlin.de>
Date: Mon, 24 May 2010 17:29:28 -0400
Message-ID: <AANLkTin6C4GKraeOfr_UKxMlAQ1a3EMoaJOZVOb1faPq@mail.gmail.com>
Subject: Re: [PATCH] ieee1394: schedule for removal
From: Jarod Wilson <jarod@wilsonet.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 3:31 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> All application domains that are supported by the old ieee1394 driver
> stack are supported by the newer firewire driver stack too.  (FireWire
> audio came last, in 2.6.32.)  There is now good and extensive experience
> with the newer stack from deployment in Fedora since F7 as well as by
> enthusiast users of other distributions.  The new drivers have
> consequently been recommended as the default ones since 2.6.33, in order
> to fix some severe usability problems of FireWire on Linux due to
> limitations of the old stack.  It is now high time to announce when the
> obsolete drivers will be removed.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Good riddance.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
