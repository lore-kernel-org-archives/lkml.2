Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1JTDk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 23:40:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:38335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1JTDk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 23:40:56 -0400
Message-ID: <4E9F983E.7000601@infradead.org>
Date: Thu, 20 Oct 2011 01:40:46 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Antonio Ospite <ospite@studenti.unina.it>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Tomas M." <tmezzadra@gmail.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: kernel OOPS when releasing usb webcam (random)
References: <4E9CB0C2.3030902@gmail.com> <alpine.DEB.2.00.1110171703210.13515@chino.kir.corp.google.com> <20111018104054.07aa2bcf462c0268a23c0139@studenti.unina.it> <alpine.DEB.2.00.1110181332320.2639@chino.kir.corp.google.com> <alpine.DEB.2.00.1110191321200.2892@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110191321200.2892@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-10-2011 18:21, David Rientjes escreveu:
> On Tue, 18 Oct 2011, David Rientjes wrote:
> 
>> Guennadi or Mauro, how is this going to Linus?  It sounds like 3.1 
>> material since we've received at least a couple of reports of this in the 
>> past week.
>>
> 
> This fix is now in Linus' tree at e58fced201ad ("[media] videodev: fix a 
> NULL pointer dereference in v4l2_device_release()") for 3.1.

Yes, I sent it upstream earlier today. Btw, Greg also picked it for stable.
It should be there for the next 3.0.x kernel as well.

Regards,
Mauro
