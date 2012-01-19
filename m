Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2ASCWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:22:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45597 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2ASCWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <20120119012130.GA6050@suse.de>
References: <1326935267-4077-1-git-send-email-tomoya.rohm@gmail.com>
	<20120119012130.GA6050@suse.de>
Date: Thu, 19 Jan 2012 11:22:24 +0900
Message-ID: <CANKRQnikxUjtUjnKZ=GkV1kLUVx_N2ipSr86PiJrm=iZq_Mhaw@mail.gmail.com>
Subject: Re: [PATCH] pch_phub: add message to notify installing pch_phub
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/19 Greg KH <gregkh@suse.de>:
> No, I'm going to reject this, we have been _removing_ these types of
> garbage messages from drivers, please don't add new ones, it is
> pointless.
>

You mean you can't allow only one-line driver installed message ?
If yes, let me know your opinion about below.
How users can know the driver is installed or not ?

thanks,
tomoya
