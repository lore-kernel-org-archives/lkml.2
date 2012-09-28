Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab2I1NAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:00:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30054 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab2I1NAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:00:48 -0400
Date: Fri, 28 Sep 2012 16:00:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrzej Giniewicz <gginiu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Sound got mute in kernel 3.5.4 (Fast Track Pro USB Sound Card),
 found commit that causes it - how to proceed?
Message-ID: <20120928130034.GF28937@mwanda>
References: <505B455D.2040603@gmail.com>
 <505D816B.4080902@gmail.com>
 <50605A88.8060503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50605A88.8060503@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've filed a bugzilla entry for this.  Shouldn't be hard to fix now
that you've bisected it, thanks for that.

https://bugzilla.kernel.org/show_bug.cgi?id=48051

regards,
dan carpenter
