Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2LNJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:26:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36653 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2LNJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:26:23 -0500
Date: Fri, 14 Dec 2012 09:31:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20121214093141.7e4eba61@pyramind.ukuu.org.uk>
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F326FBFB54@szxeml546-mbs.china.huawei.com>
References: <fe8c905bb12.b12fe8c905b@huawei.com>
	<20121212105151.09635a76@pyramind.ukuu.org.uk>
	<910F9D9E13B84F4C8FA771DC9BDE99F326FBFB54@szxeml546-mbs.china.huawei.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 03:01:24 +0000
"Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> wrote:

> Dear Alan:
> 
> 	This prevents people getting access to the storage device if they want.
> 	----In our device, after its switching, it will keep the cdrom port together with other ports (such as modem port). So you can access the storage device too, after our switch.

Ok so the behaviour is

	plug in device
	"I am a CD-ROM"
	command sent
	"I am a CD-ROM, I am a modem, I am other things"

with the newer devices ?

Alan
