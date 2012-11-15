Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768232Ab2KOPH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:07:56 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61627 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768160Ab2KOPHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:07:54 -0500
MIME-Version: 1.0
X-Originating-IP: [123.193.74.78]
In-Reply-To: <1352991622.2578.9.camel@dabdike>
References: <85E5FCE3D4AD4A2D9A3DE6E64060AF05@arecaaebe11fae>
	<1352988719.2578.5.camel@dabdike>
	<CAGUPPa5rmZoG0tf3o6GSqcjUwdnd5+CPfy1WkSoO0doFv6eh4Q@mail.gmail.com>
	<1352991622.2578.9.camel@dabdike>
Date: Thu, 15 Nov 2012 23:07:52 +0800
Message-ID: <CAGUPPa6eL-_vKVjCkrHihAhKkniS0E4buWyRPuR4b-qmoUBPwA@mail.gmail.com>
Subject: Re: [PATCH 1/5] arcmsr: Re-name the HBA Type
From: =?UTF-8?B?6YSt5a6I6KyZ?= <nick.cheng@areca.com.tw>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I will fix it.
Thank you,
2012/11/15 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Thu, 2012-11-15 at 22:53 +0800, 鄭守謙 wrote:
>> Hi James,
>> You got these errors/warnings before or after you apply these 5 patches?
>
> I got all of this lot from patch 1/5 only.  Please fix at least the
> errors and the warnings that go to whitespace issues.  I don't really
> care about printk(KERN_ERR vs pr_err( or lines over 80 characters.
>
> James
>
>
