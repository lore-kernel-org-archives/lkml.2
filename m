Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0IXRCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:02:17 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:33413 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0IXRCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:02:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C9CDAD6.6080605@cam.ac.uk>
Date: Fri, 24 Sep 2010 18:07:34 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>, Takashi Iwai <tiwai@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH v2] lis3: Fix Oops with NULL platform data
References: <s5heiclngqe.wl%tiwai@suse.de> <20100924135802.GA18109@ericsson.com> <s5hlj6r1b5p.wl%tiwai@suse.de> <20100924163005.7704f63e@endymion.delvare> <4C9CBF4E.7080200@cam.ac.uk> <20100924151759.GC18153@ericsson.com>
In-Reply-To: <20100924151759.GC18153@ericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/10 16:17, Guenter Roeck wrote:
> On Fri, Sep 24, 2010 at 11:10:06AM -0400, Jonathan Cameron wrote:
> [...]
>> Technically hwmon is orphan (according to MAINTAINERS.) But that's not to
> 
> If you pull the latest tree, you'll notice that this is no longer correct.
Excellent!  Glad you two have stepped up, sorry for the misinformation.

I may well have missed it, but if not perhaps a general announce email to the
lm-sensors list to announce it may be worth while to alert anyone like me who
is working on slightly aging branches? (staging-next :)
