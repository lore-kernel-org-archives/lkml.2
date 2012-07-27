Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2G0Gp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:45:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15263 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2G0GpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:45:24 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-b4-501238f94a39
Message-id: <501238FB.6020403@samsung.com>
Date: Fri, 27 Jul 2012 15:45:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Implement button detection support
References: <1342800449-10328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <500F8DB4.30401@samsung.com>
 <20120725111105.GI3099@opensource.wolfsonmicro.com>
 <50108AE0.5070502@samsung.com>
 <20120726081110.GA26373@opensource.wolfsonmicro.com>
In-reply-to: <20120726081110.GA26373@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd2fFkIBBrcvK1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MniXrmQoWslbcPP+AtYFxIksXIyeHhICJRMOuFihbTOLCvfVs
	ILaQwHRGiavfXLoYuYDsLiaJGy/+MYEkeAW0JG792sIKYrMIqEr8PPsEzGYDiu9/cQOomYND
	VCBC4lc/B0S5oMSPyfdYQMIiQLt+368EGckssJhR4s+eB4wgNcICHhK3O1exQ+xqYpK4OLMX
	LMEp4ChxZ/s2sL3MAjoS+1unsUHY8hKb17xlnsAoMAvJjllIymYhKVvAyLyKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzgAn0ntYFzZYHGIUYCDUYmHdyKvUIAQa2JZcWXuIUYJDmYlEd7n
	fEAh3pTEyqrUovz4otKc1OJDjNIcLErivMbeX/2FBNITS1KzU1MLUotgskwcnFINjC7WR5lP
	e/Sap8qLl5uqaloamBT3Lsy+G7apxXqt7qsK985Zue9dNBV/Re+WkXrLXHIo+63NrnNM4dW1
	WxPfbeicXPim6eHDl+0R0d9C2+PW5ge4+Uu9CD91isu04+EvyySPB898szZ/nJY8SzHo5JEn
	x93FTrZMufU9TfhCRHPHu43r/hXLK7EUZyQaajEXFScCAMrYhjU8AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 05:11 PM, Mark Brown wrote:

> On Thu, Jul 26, 2012 at 09:10:08AM +0900, Chanwoo Choi wrote:
> 
>> If user press BTN_0 and BTN_1 at the same time and then user only
>> released BTN_0 but BTN_1 is still pressed, is it right that report
>> released event to all of buttons? I think that different event between
>> BTN_0 and BTN_1.
> 
> That situation can't occur, the hardware can only detect one button at
> once - if two buttons are pressed simultaneusly only one will be
> reported.  This is just a standard resistive headset button detection
> mechanism.
> 

OK,

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thank you,
Chanwoo Choi
