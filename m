Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2GPAlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 20:41:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50904 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2GPAlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 20:41:06 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-a0-50036320398f
Message-id: <5003631F.50602@samsung.com>
Date: Mon, 16 Jul 2012 09:41:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] charger-manager: Use EXTCON Subsystem to control
 charger cable
References: <1342072996-9391-1-git-send-email-cw00.choi@samsung.com>
 <20120714013727.GA9556@lizard>
In-reply-to: <20120714013727.GA9556@lizard>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAV2FZOYAg303TS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrS+fmAoOMlfMP7GdvYHxNVMXIyeHhICJxI2X3xghbDGJC/fW
	s3UxcnEICSxilFh1+AMLhNPFJPG4/ywbSBWvgIbE36OnmUFsFgFViXtH34PZbAJaEvtf3ACq
	4eAQFYiQ+NXPAVEuKPFj8j0WEFtEQEfi880msAXMAj2MEl9ObgCbKSwQKTFtwlZ2EFtIIFXi
	xexmsJmcAtoS74/tB7uUWUBdYtK8RcwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLUgu
	KE5KzzXUK07MLS7NS9dLzs/dxAgOwWdSOxhXNlgcYhTgYFTi4TWIYw4QYk0sK67MPcQowcGs
	JMJ7ORQoxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfY+6u/kEB6YklqdmpqQWoRTJaJg1OqgbEo
	XOLKdLa0Fz1C4lc2rhQR3LrVeH9hxUePgrk3O5ZPirm+zFlql9iDbUZ3l55/Xv/8tMCjraqV
	G9R9drKfbOgXuqN6QPLAvyUPrCyL+9L79x5+Kd2Wd+by3+3ZvIoOE3bdzrZ9n6s97VP/7B0q
	Qfs8Nade2DUj4Nr3kllz5zCsl7XYn9NZni6oxFKckWioxVxUnAgA2e8gJT0CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2012 10:37 AM, Anton Vorontsov wrote:

> On Thu, Jul 12, 2012 at 03:03:16PM +0900, Chanwoo Choi wrote:
>> This patchset add support EXTCON Subsystem in which charger-manager identify
>> the type of external connector and enable/disable charger(regulator) according
>> to the state of charger cable(external connector).
> 
> Applied, thanks a lot!
> 

Thank you four your reply and quickly applied.

Best Regards,
Chanwoo Choi
