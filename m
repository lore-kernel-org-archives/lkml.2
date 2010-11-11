Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0KKXQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:16:16 -0500
Received: from antispam01.maxim-ic.com ([205.153.101.182]:54711 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab0KKXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:16:15 -0500
X-ASG-Debug-ID: 1289517374-1a8b09ca0001-xx1T2L
X-Barracuda-Envelope-From: Jesse.Marroquin@maxim-ic.com
X-Barracuda-Apparent-Source-IP: 180.0.34.46
Message-ID: <4CDC793C.2040406@maxim-ic.com>
Date: Thu, 11 Nov 2010 17:16:12 -0600
From: Jesse Marroquin <jesse.marroquin@maxim-ic.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Add MAX98089 CODEC driver
References: <4CDC5033.50302@maxim-ic.com> <20101111211801.GA3399@opensource.wolfsonmicro.com>
X-ASG-Orig-Subj: Re: [PATCH] ASoC: Add MAX98089 CODEC driver
In-Reply-To: <20101111211801.GA3399@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2010 23:16:38.0439 (UTC) FILETIME=[7DE68B70:01CB81F6]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1289517374
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.12
X-Barracuda-Spam-Status: No, SCORE=0.12 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46364
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for pointing out the I2C device ID. After looking at the existing
drivers that have multiple I2C IDs, I see that the devices can be uniquely
identified. With this we should be able to accommodate both devices with
the same driver.


On 11/11/2010 03:18 PM, Mark Brown wrote:
> On Thu, Nov 11, 2010 at 02:21:07PM -0600, Jesse Marroquin wrote:
>> This patch adds the initial driver for the MAX98089 CODEC.
> 
> I've not read this properly yet but on a first quick scan through this
> bears a more than passing resemblance to the MAX98088 driver - are there
> sufficient incompatibilities between the chips to warrant having a
> separate driver?  http://datasheets.maxim-ic.com/en/ds/MAX98088.pdf
> would suggest not...  
> 
> Keeping a single driver means less code to maintain, which is generally
> a win.  Variations between the parts can be accommodated by registering
> different controls and so on based on the I2C device ID that the system
> registers.
> 

