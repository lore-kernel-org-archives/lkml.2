Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1EGBaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:30:25 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58366 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753330Ab1EGBaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:30:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 21:30:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rOw5dGvmnKDVAcGMoRk6IGUhnBk/UUoPEVUAFcJBx1qYHMdr1QQC7HP22QNzbLmoL+A0cBQaiByWHEmhEsjmvyjEfX1fGmMSIyHtqpCzMgmOBTNzVWePRjsU5WkwVslN;
Date: Fri, 6 May 2011 18:23:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: akpm@linux-foundation.org, Esben Haabendal <eha@doredevelopment.dk>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-05-06-16-39 uploaded (leds)
Message-Id: <20110506182341.d2cd8a19.rdunlap@xenotime.net>
In-Reply-To: <201105070015.p470FlAR013200@imap1.linux-foundation.org>
References: <201105070015.p470FlAR013200@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 May 2011 16:39:31 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-05-06-16-39 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.39-rc6:


As reported on April 15 of 2011 in
Subject: Re: mmotm 2011-04-14-15-08 uploaded (leds)


from leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch:

This build error happened several times when
CONFIG_LEDS_TRIGGERS is not enabled:

drivers/leds/led-class.c:134: error: 'struct led_classdev' has no member named 'trigger_data'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
