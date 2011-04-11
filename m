Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1DKSgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:36:43 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:39582 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1DKSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:36:42 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DA34AA5.3020700@cam.ac.uk>
Date: Mon, 11 Apr 2011 19:38:29 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tglx@linutronix.de
Subject: Re: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev
 combining and rewrite of triggers as 'virtual' irq_chips.
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a quick heads up.  I am not intending to repost this series
to lkml.  Given with carrying drivers through past 
"staging:iio: Remove legacy event handling" has resulted
in over 50 patches that are mostly very much driver specific,
it seems silly to bombard the general list.

I will be posting that set on linux-iio if anyone is interested
(after a little more cleaning up).

I will cherry pick a few bits such as the additional
exports from genirq to post to lkml.

Seems rude to drop a huge patch set on everyone when
only a few corners will be of general interest.

Jonathan

