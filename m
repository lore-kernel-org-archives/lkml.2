Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1JCJpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:45:42 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:60752 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1JCJpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:45:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E898636.8000306@cam.ac.uk>
Date: Mon, 03 Oct 2011 10:53:58 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110930 Thunderbird/6.0.2
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88AF15.7000503@xenotime.net> <20111002225434.GA22333@ericsson.com>
In-Reply-To: <20111002225434.GA22333@ericsson.com>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/11 23:54, Guenter Roeck wrote:
> On Sun, Oct 02, 2011 at 02:36:05PM -0400, Randy Dunlap wrote:
>> On 10/02/11 04:54, Rafael J. Wysocki wrote:
>>> On Sunday, October 02, 2011, H. Peter Anvin wrote:
>>>> On 10/01/2011 06:04 PM, Rafael J. Wysocki wrote:
>>>>>
>>>>> OK, I'm taking this as "5 years is fine by us". :-)
>>>>>
>>>>> And the recommended procedure for rotating keys seems to be (1) generate
>>>>> a new key and (2) make as many people as you can sign it before the old
>>>>> one expires, right?
>>>>>
>>>>
>>>> (3) revoke the old key with a status code of "no longer in use", or just
>>>> let it expire.
>>>>
>>>>>> Some people have decided to opt for an unlimited key, but that
>>>>>> *requires* that you have a way to revoke the old key, which is why we
>>>>>> are considering a key revocation escrow service.
>>>>>
>>>>> That service will be necessary anyway in case some keys are lost or
>>>>> compromised.
>>>>>
>>>>> I wonder what the procedure of restoring kernel.org access in case one
>>>>> has lost keys is supposed to be?
>>>>
>>>> Get a new key and get it re-signed.
>>>
>>> Hmm.  That doesn't seem very practical if someone doesn't live close
>>> to any other core kernel developers.
>>>
>>> What number of signatures on the key will be regarded as sufficient?
>>>
>>>> We can work out specific details at KS.
>>>
>>> Well, the KS is going to be busy time this year I suppose. :-)
>>>
>>> What about people who haven't been invited to the KS?
>>
>> They (we) should start building a web of trust with local key signings.
>> I'm already working on that in Portland, Oregon.
>>
> Anyone in Silicon Valley looking for key signings, please get in touch.

Similarly anyone Cambridge UK based (or London I guess) please get in touch.
