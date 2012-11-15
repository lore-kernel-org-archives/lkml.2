Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768157Ab2KOPAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:00:51 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37463 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768118Ab2KOPAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:00:50 -0500
Message-ID: <1352991622.2578.9.camel@dabdike>
Subject: Re: [PATCH 1/5] arcmsr: Re-name the HBA Type
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?UTF-8?Q?=E9=84=AD=E5=AE=88=E8=AC=99?= <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 07:00:22 -0800
In-Reply-To: <CAGUPPa5rmZoG0tf3o6GSqcjUwdnd5+CPfy1WkSoO0doFv6eh4Q@mail.gmail.com>
References: <85E5FCE3D4AD4A2D9A3DE6E64060AF05@arecaaebe11fae>
	 <1352988719.2578.5.camel@dabdike>
	 <CAGUPPa5rmZoG0tf3o6GSqcjUwdnd5+CPfy1WkSoO0doFv6eh4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 22:53 +0800, 鄭守謙 wrote:
> Hi James,
> You got these errors/warnings before or after you apply these 5 patches?

I got all of this lot from patch 1/5 only.  Please fix at least the
errors and the warnings that go to whitespace issues.  I don't really
care about printk(KERN_ERR vs pr_err( or lines over 80 characters.

James


