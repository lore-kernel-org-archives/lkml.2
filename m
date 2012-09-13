Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2IMM0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:26:09 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:37264 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab2IMM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:26:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <5051D0E0.1020505@kernel.org>
Date: Thu, 13 Sep 2012 13:26:08 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: anish singh <anish198519851985@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, cbou@mail.ru,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
References: <1347291621-8530-1-git-send-email-anish198519851985@gmail.com> <504F0B9B.2050504@metafoo.de> <CAK7N6vpn8NiXaPztWv4uo5hjm44252bxZ-WKZoLaoEQCi6rieA@mail.gmail.com>
In-Reply-To: <CAK7N6vpn8NiXaPztWv4uo5hjm44252bxZ-WKZoLaoEQCi6rieA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
> Thanks Lars, all of your comments are valid and I will accordingly update.
> I am waiting for some more review comments if there is any and will send
> the updated code.
  Beware of that strategy as I for one am guilty of the old approach of 
'oh look someone else has commented, I'll wait for the
next version before taking a look' - particularly when it's a good
reviewer like Lars

