Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0EFTXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:23:51 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:41787 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0EFTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XMkrFYS167pOg2I13FGJJWEZMLG9ZAf2Zcip4qAcO6cjLi6N/GEQC8v4w8v8Hspe59
         V+VosaLa3g5TnUf9CPs09dwm6I/Ev9Bnh7b9CfMTnIaEAVNaXDsSWudV/7CCGK4jmcD4
         inVNUZ/JVKEcocL7Sle3VkEAP1M/HbCS4xqys=
MIME-Version: 1.0
In-Reply-To: <20100506191532.GA11365@oksana.dev.rtsoft.ru>
References: <20100506191532.GA11365@oksana.dev.rtsoft.ru>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 6 May 2010 15:23:28 -0400
Message-ID: <l2s8bd0f97a1005061223zc29b43fdp1e5f722680bdd4b2@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1760: Soften DW3 X/transaction error bit handling
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Bryan Wu <cooloney@kernel.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 15:15, Anton Vorontsov wrote:
> [3] http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=5148

i doubt you feel like resending, but this is a better link:
  http://blackfin.uclinux.org/gf/tracker/5148
-mike
