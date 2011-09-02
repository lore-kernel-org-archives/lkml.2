Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1IBOsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:48:04 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:33855 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab1IBOr7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <1314973961-21187-1-git-send-email-peter.ujfalusi@ti.com>
References: <1314973961-21187-1-git-send-email-peter.ujfalusi@ti.com>
Date: Fri, 2 Sep 2011 17:47:58 +0300
Message-ID: <CAPo=G1yOr8iMvtR7u4hFEqG01m4mQiu4_mmu7ecWX1BpqbbNew@mail.gmail.com>
Subject: Re: [PATCH 0/3] MFD/Input: twl6040 (vibra): cleanups
From: "Ujfalusi, Peter" <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 2, 2011 at 5:32 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hello,
>
> Small cleanups for the twl6040 MFD driver:
> removing the global pointer for the platform_device, and adding accessor
> to fetch the revision ID of the IC.

Please ignore this series, I have missed one place, where the
revision id is accessed within the twl6040-core driver.
I have also spotted one unrelated error in the core driver.
Will resend shortly.

-- 
Péter
