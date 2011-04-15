Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1DOPuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:50:04 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:53960 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751096Ab1DOPuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:50:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UTyF80Tt6peTWB70oLKS2xb+q4lZVoPhwUy27MEWrOHt0xzsufyYpLYkk2kP9ZZIo1/3elbj0bivFPlU1fs0+6tBOBsZuWHRvL8m0Yz4qPWWggGmp+nefcq7FBpWU/nb;
Date: Fri, 15 Apr 2011 08:50:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Esben Haabendal <eha@doredevelopment.dk>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: mmotm 2011-04-14-15-08 uploaded (leds)
Message-Id: <20110415085000.3f057fec.rdunlap@xenotime.net>
In-Reply-To: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 15:08:47 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-04-14-15-08 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git


from leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch:

This build error happened several times when
CONFIG_LEDS_TRIGGERS is not enabled:

drivers/leds/led-class.c:134: error: 'struct led_classdev' has no member named 'trigger_data'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
