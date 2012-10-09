Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2JIGQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:16:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42329 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2JIGQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:16:41 -0400
Date: Mon, 8 Oct 2012 23:16:33 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 27/30] ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop
Message-ID: <20121009061633.GA3648@elie.Belkin>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
 <67bfa9b60bd689601554526d144b21d529f78a09.1349761836.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67bfa9b60bd689601554526d144b21d529f78a09.1349761836.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:

> By enlarging the GPE storm threshold back to 20, that laptop's
> EC works fine with interrupt mode instead of polling mode.

What would go wrong if the threshold were just increased to 20 on all
models?

Thanks,
Jonathan
