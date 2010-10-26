Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0JZWzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 18:55:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48641 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab0JZWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 18:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Qkkm5am+mNLEcaAQHB0PAx7ppYS3plWFk3Hxh2OrBXd5yenEdOKFopFk7PcUA6oRfP
         KewxtMUKnH8+SObT1KtmtIVLhJhwkJC8xYnOTSexLqNwQx+wuHbDtVIy69xhm5+U/F6l
         VcgVU2F/opzeyh0+xHoB4l30yvarPiA45kGik=
Subject: Re: memstick: Alternative approach to proposed fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1288114871-805-1-git-send-email-oakad@yahoo.com>
References: <1288114871-805-1-git-send-email-oakad@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 00:55:39 +0200
Message-ID: <1288133739.15918.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 04:41 +1100, Alex Dubov wrote:
> As I was not able to convince myself that profound changes proposed by Maxim
> are really necessary, I propose to follow a much milder path with this update
> round (as I outlined in my previous emails).
It is really sad to see that patchset.


> 
> In this small patchset, I fix a couple of small omissions as well as introduce
> support for "extended command" MSPro transfer method (currently enabled for
> JMicron, but I'll clear the TI host for this functionality soon). I expect the
> current solution to scale trivially for HG and XC transfer methods (I don't
> have the spec for the later yet).
Indeed small.
All the changes in this patchset are really minor and optional.
I could have dropped them.


I did much more that that.
I made the memstick code readable so not only you could understand it
I also wrote ms_block.c while adding common support.
I made your code use that support.

It is really sad that you are doing that.



