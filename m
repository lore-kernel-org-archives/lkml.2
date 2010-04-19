Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0DSOKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:10:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0DSOKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:10:12 -0400
Message-ID: <4BCC63EB.4010204@redhat.com>
Date: Mon, 19 Apr 2010 16:08:43 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: digidietze@draisberghof.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: expose Huawei E1550 3G modem
References: <4BCC5071.4010509@redhat.com> <4BCC6206.4030003@draisberghof.de>
In-Reply-To: <4BCC6206.4030003@draisberghof.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.2010 16:00, Josua Dietze wrote:
> Stefan Assmann schrieb:
>> The Huawei E1550 3G modem is hidden by default and can be
>> exposed by sending some magic initialization code. This
>> patch takes care of that.
> 
> This device (as all other Huaweis using this sequence) is 
> supported by the usb_modeswitch tool which takes of the 
> switching process. Once installed, no user interaction is 
> required except plugging.
> 
> Current policy is to leave switching to the userspace if it's 
> working there.

Hi Josua,

that's good news. This is part of hardware initialization, so let's move
it to the kernel. Or do you know any good reason why the kernel
shouldn't handle it?

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
