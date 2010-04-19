Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0DSOTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:19:17 -0400
Received: from 007.netroom.de ([194.0.247.207]:28454 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab0DSOTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:19:16 -0400
X-Greylist: delayed 1112 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 10:19:16 EDT
Message-ID: <4BCC6206.4030003@draisberghof.de>
Date: Mon, 19 Apr 2010 16:00:38 +0200
From: Josua Dietze <digidietze@draisberghof.de>
Reply-To: digidietze@draisberghof.de
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: expose Huawei E1550 3G modem
References: <4BCC5071.4010509@redhat.com>
In-Reply-To: <4BCC5071.4010509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann schrieb:
> The Huawei E1550 3G modem is hidden by default and can be
> exposed by sending some magic initialization code. This
> patch takes care of that.

This device (as all other Huaweis using this sequence) is 
supported by the usb_modeswitch tool which takes of the 
switching process. Once installed, no user interaction is 
required except plugging.

Current policy is to leave switching to the userspace if it's 
working there.


Josua Dietze
