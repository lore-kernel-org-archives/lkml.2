Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2JAGjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:39:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2JAGjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:39:04 -0400
Message-ID: <50693A84.8010102@gmail.com>
Date: Sun, 30 Sep 2012 23:39:00 -0700
From: Stephen Boyd <bebarino@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110911 Thunderbird/6.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org
Subject: Re: rt73usb WARNING: at net/mac80211/driver-ops.h:12 check_sdata_in_driver
References: <505AD51F.7050709@gmail.com> <20120928124632.GG5368@mwanda>
In-Reply-To: <20120928124632.GG5368@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 05:46 AM, Dan Carpenter wrote:
> Hi Stephen,
> 
> I have created a bug for this:
> https://bugzilla.kernel.org/show_bug.cgi?id=48041
> 
> We only recently added the warning on that path.
> 
> Please add the following information.
> *) Complete dmesg
> 

Ok I've added the information to the bug. I'm still seeing it on 3.6.

