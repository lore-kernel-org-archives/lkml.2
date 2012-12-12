Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab2LLKql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:46:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33620 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LLKqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:46:39 -0500
Date: Wed, 12 Dec 2012 10:51:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zihan@huawei.com>, <Lin.Lei@huawei.com>, <greg@kroah.com>,
        <neil.yi@huawei.com>, <wangyuhua@huawei.com>, <huqiao36@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20121212105151.09635a76@pyramind.ukuu.org.uk>
In-Reply-To: <fe8c905bb12.b12fe8c905b@huawei.com>
References: <fe8c905bb12.b12fe8c905b@huawei.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012 18:20:33 +0800
fangxiaozhi 00110321 <fangxiaozhi@huawei.com> wrote:

> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. To optimize the match rules for the Huawei USB storage devices. Avoid to load USB storage driver for modem interface with Huawei devices.
> 2. Add to support new switch command for new Huawei USB dongles.

This prevents people getting access to the storage device if they want.
It also means you need to change kernel not simply a user space file to
add support for different new identifiers.

So it seems a large step backwards to me.

Why not just teach udev the new switch command then it'll work as a udev
update on all sorts of existing kernels as well as being the kind of
small safe change you can get into the entprise distributions ?

Alan
