Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2GJCCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:02:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJCCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:02:48 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-4b-4ffb8d46ee52
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>,
        sbkim01@gmail.com
References: <0fed01cd5c24$5dd3ebc0$197bc340$@com>
 <20120709111308.GL15345@sortiz-mobl>
In-reply-to: <20120709111308.GL15345@sortiz-mobl>
Subject: RE: [PATCH V2 0/7] Initial release of Samsung S2MPS11 pmic driver
Date: Tue, 10 Jul 2012 11:02:46 +0900
Message-id: <008201cd5e40$197c5930$4c750b90$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1dwjeD5g5LEoIpQ8u+DTwE740lXwAfZiFg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAV233t/+Bj1HFS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG6oYT7AV3OCu6z81gbmC8wN7FyMkhIWAiMenQMUYIW0ziwr31
	bF2MXBxCAosYJZa/a2OEcOYySSxb+xKsik1AQ2Ll7rdsILaIgJZE97HzYB3MAu2MEp3tEKOE
	BCIkJk6dApTg4OAUMJToOGIMEhYW8JLYc+4iI0iYRUBV4tEZBRCTF6ii83M8SAWvgKDEj8n3
	WEBsZqDp63ceZ4Kw5SU2r3nLDFIuIaAu8eivLsQBRhIr3l1khigRkdj34h3jBEahWUgmzUIy
	aRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzEz6R3MK5qsDjEKMDBqMTD
	q5H321+INbGsuDL3EKMEB7OSCO8tV6AQb0piZVVqUX58UWlOavEhRmkOFiVxXhPvr/5CAumJ
	JanZqakFqUUwWSYOTqkGxmxOpoL8gJDplyM25vO9lM6qX2Tes0QmK7HWckfx12ve22YJzD1/
	pfvby/NNPst4Dj+r7N75tKvlY2DRgUubjVuTGzc8fPRjSy7bisg01dfGNev7cpJsI2xj2R+y
	V72dWyKqE6vKEvm6nzFzyb3PeSLz1WLfbRdjilzalrHs461Pmu67ucSuKrEUZyQaajEXFScC
	ADF9TEBeAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Mon, Jul 09, 2012 at 08:13PM +0900, Samuel Ortiz wrote:
> Hi Sangbeom,
> 
> On Sat, Jul 07, 2012 at 06:39:12PM +0900, Sangbeom Kim wrote:
> > The S2MPS11 is comprised of high efficient Buck converters,
> > various LDOs, and an RTC and tightly coupled with Multi Core Samsung
> > Application Processors, which is used in a wide variety of mobile applications
> > such as smart phones and tablet PCs.
> > S2MPS11 provide 10 high efficiency buck converters and 38 LDO regulators.
> > Especially, Buck2 can support 7.0A current capacity for high performance
> > samsung application processor.
> > Most of S2MPS11 feature are similar to S5M series.
> > and Instead of using s5m prefix, Samsung decide to use s2m prefix.
> > So, I try to make common mfd driver for S2M and S5M series.
> > Most of s5m prefix is changed into sec prefix.
> >
> > Changes since V1:
> > 1. Replace list_voltage with standard framework
> > 2. Apply regmap_irq
> > 3. Minor changes.
> I was trying to apply this patchset to my for-next branch, but it doesn't
> apply properly.
> Could you please rebase it against this branch and send it to me ?
> 
> Cheers,
> Samuel.

Sorry, After rebase it, I will send again.

Thanks,
Sangbeom.

