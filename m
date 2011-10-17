Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1JQOF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:05:29 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:54472 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQOF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:05:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9C362B.3080502@cam.ac.uk>
Date: Mon, 17 Oct 2011 15:05:31 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <20111017101959.GC3042@opensource.wolfsonmicro.com> <4E9C0423.5010909@cam.ac.uk> <20111017104642.GD3042@opensource.wolfsonmicro.com> <4E9C0DD7.7080105@cam.ac.uk> <20111017111807.GA27266@opensource.wolfsonmicro.com> <4E9C1249.5020408@cam.ac.uk> <20111017120813.GB27266@opensource.wolfsonmicro.com> <4E9C201D.30905@cam.ac.uk> <20111017124807.GD27266@opensource.wolfsonmicro.com> <4E9C27B9.50504@cam.ac.uk> <20111017135508.GE27266@opensource.wolfsonmicro.com>
In-Reply-To: <20111017135508.GE27266@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 14:55, Mark Brown wrote:
> On Mon, Oct 17, 2011 at 02:03:53PM +0100, Jonathan Cameron wrote:
>> On 10/17/11 13:48, Mark Brown wrote:
> 
>>>> 0...4
>>>> 1...5
>>>> AUXA....AUXD
>>>> TEMP_EXT1...TEMP_EXT5 (all of which are just normal adc channels that some
>>>> designer decided would be used only for connecting analog temperature sensors.)
> 
>>> None of those look at all unreasonable
> 
>> Fair enough though the temp one is at least stupid, but why should
>> we match them?
> 
> So that the engineer sitting there with the schematics can figure out
> how to tell software about the board hookup with minimal pain.
Fine, I'll code it up and we'll see what works for the cases we have.
> 
>> Ok, so we could add to every channel a magic matching field called
>> datasheet_name?  To my mind its silly overhead, but if there is a
>> consensus on it then fine.  Note however that any remotely general
>> purpose userspace will not read these values even if we make
>> them available.
> 
> That depends, if the userspace is really general purpose I'd expect it'd
> be exposing this information to let the user point and click (or
> whatever) through the channels.  Otherwise they'll be scratching their
> heads wondering what channel 0 on this particular system actually is.
> 
True enough, though ultimately it would be nice if it is easy enough to
work out that they can put sticky labels on the wires...  Lets call these
channel_label and keep them optional for now. If nothing else I don't
really fancy retrofitting our 50+ existing drivers with them all in
one go.

Jonathan

