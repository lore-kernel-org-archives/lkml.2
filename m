Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2LTNvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:51:19 -0500
Received: from mout.gmx.net ([212.227.15.19]:64484 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab2LTNvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:51:10 -0500
X-Greylist: delayed 3032 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 08:51:09 EST
X-Authenticated: #20566476
X-Provags-ID: V01U2FsdGVkX1/c2zxSZg7c7xgb7EN5LktErSLG4W97Pbx1YUCy/r
	K679J8xnZl1RLw
MIME-Version: 1.0
In-Reply-To: <20121220132059.3cc85cfd@pyramind.ukuu.org.uk>
References: <CAALC5YGq=DL1LWCb6QjqkACJLo6Z8SgwjNYoMXtvFF7a9KGhDg@mail.gmail.com>
 <20121220132059.3cc85cfd@pyramind.ukuu.org.uk>
From: "Christian Bahls - gmx.de" <christian.bahls@gmx.de>
Date: Thu, 20 Dec 2012 14:50:36 +0100
Message-ID: <CAALC5YHxfQOcbOEASy_1uH=K-GMVc3Xs0yvjby-hw1fcW7Khhw@mail.gmail.com>
Subject: Re: Encrypted block devices and suspend to ram
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 2:20 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> man cryptsetup

"WARNING: never suspend the device on which the cryptsetup binary resides."

I use full disk encryption and the cryptsetup binary is from initramfs

kind regards
 Christian Bahls
