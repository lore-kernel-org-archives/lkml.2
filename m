Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1JQLNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:13:25 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:44349 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1JQLNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:13:24 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9C0DD7.7080105@cam.ac.uk>
Date: Mon, 17 Oct 2011 12:13:27 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk> <1318333383-17663-2-git-send-email-jic23@cam.ac.uk> <20111013143224.GO1098@sirena.org.uk> <4E96F9AC.9000001@cam.ac.uk> <20111013204410.GA17160@sirena.org.uk> <4E985C60.9020308@cam.ac.uk> <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com> <4E9BF8D9.8030301@cam.ac.uk> <20111017101959.GC3042@opensource.wolfsonmicro.com> <4E9C0423.5010909@cam.ac.uk> <20111017104642.GD3042@opensource.wolfsonmicro.com>
In-Reply-To: <20111017104642.GD3042@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 11:46, Mark Brown wrote:
> On Mon, Oct 17, 2011 at 11:32:03AM +0100, Jonathan Cameron wrote:
> 
>> Initially I'd be tempted to only support numbered channels (on adc side).
>> Later we can add the named option - iff it has real use cases.
> 
> I think the PMIC case is a real one, assigning numbers people need to
> use to find things is doesn't really reflect actual usage.
> 
Just to make sure I'm understanding you correctly could you give an example
part.  The supplies one we explicitly handle anyway so I'm happy with that
one, I just want to confirm that this is what you are talking about.

Anyhow, should get to code this afternoon and always easier to discuss
actual code!  
