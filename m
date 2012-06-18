Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2FRCy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:54:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59323 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2FRCy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:54:28 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <3920966.545511339987371711.JavaMail.weblogic@epml17>
References: <3920966.545511339987371711.JavaMail.weblogic@epml17>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 18 Jun 2012 10:54:07 +0800
Message-ID: <CAF+7xWmSsFDWVqRakSz3BP_pFEK_i4DUtw-03gwp3rCZrLicsg@mail.gmail.com>
Subject: Re: [PATCH] extcon: max8997: Add missing kfree for info->edev in max8997_muic_remove()
To: myungjoo.ham@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/18 함명주 <myungjoo.ham@samsung.com>:
>> extcon_dev_unregister(info->edev) doest not free info->edev, we need to call
>> kfree(info->edev) here.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> The patch is correct.
>
> However, using devm_kzalloc at probe and removing kfree at remove appears to be much better.
Yes, But I think Greg may prefer this one-linear for 3.5.
And another patch for the devm_kcalloc conversion for 3.6.

Regards,
Axel
