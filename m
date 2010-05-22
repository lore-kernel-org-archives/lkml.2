Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0EVS2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:28:34 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:41446 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab0EVS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=NJUfT+2+P8CEbu9/AZ5yt4xiYJbKuwMqkZEuW6N34hYO659uWRzel9/4MqxmF/AVEb
         GvC7Iyk0BfEOHZiJac+qcvO2t3nJjmYO53yyvm5pcmOppnzFXJeHyFv8cseIzVHxOKNI
         BG37o1vNkduweIH6iV/gyZIcotg/gSHKS7JDo=
MIME-Version: 1.0
In-Reply-To: <1269567614-26995-1-git-send-email-henne@nachtwindheim.de>
References: <1269567614-26995-1-git-send-email-henne@nachtwindheim.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 22 May 2010 14:28:11 -0400
Message-ID: <AANLkTilRxTBdWeL9sJHUhMgr9GhNnGTGNFEotMHtxSqn@mail.gmail.com>
Subject: Re: [PATCH] mfd: section cleanup of 88pm860x driver
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 21:40, Henrik Kretzschmar wrote:
> This patch fixes three section mismatches.

fixes things for me too, thanks
Signed-off-by: Mike Frysinger <vapier@gentoo.org>

should go into stable too i think ... but i guess it needs to be
merged for 2.6.35 first ...
-mike
