Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1HDVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:16:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47375 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab1HDVQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108042247000.1424@ask.diku.dk>
References: <1312490574-14804-1-git-send-email-prtvar.b@gmail.com>
	<Pine.LNX.4.64.1108042247000.1424@ask.diku.dk>
Date: Thu, 4 Aug 2011 23:16:49 +0200
Message-ID: <CAOmT4fThjOjBAcXmFqpqct3uzVOi3eQWknyD3TO+aC6CDXEnuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: kfree() NULL pointer cleanup
From: bojan prtvar <prtvar.b@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 10:48 PM, Julia Lawall <julia@diku.dk> wrote:
> On Thu, 4 Aug 2011, Bojan Prtvar wrote:
>
> I would find it even nicer to just add a new lavel to skip over the kfree
> in the case where pm is NULL.  It is statically apparent in the source
> code.

Yes, it would be nicer. I'll send v2.

Regards,
Bojan
