Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0FGKps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 06:45:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36256 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab0FGKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 06:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinrRP_GYZiFRv_WzLnS_XGc9f0n-4V9GfZ-WVBQ@mail.gmail.com>
References: <AANLkTikgWif5ACj4Zm_4eFbx5cAipxMHd5vR4wcYePEZ@mail.gmail.com> 
	<AANLkTinrRP_GYZiFRv_WzLnS_XGc9f0n-4V9GfZ-WVBQ@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 7 Jun 2010 12:45:24 +0200
Message-ID: <AANLkTilAHHvYcZ5QujxJphACIbOu0Cc6WsctMhB3lTZI@mail.gmail.com>
Subject: Re: Unable to boot after "ACPI: Don't let acpi_pad needlessly mark 
	TSC unstable"
To: Venkatesh Pallipadi <venki@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Chen Gong <gong.chen@linux.intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venki,

On Mon, Jun 7, 2010 at 5:33 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> Hmm... Do you have the actual message you see on fault?
> Does the problem happen at the boot time?

Yes, the problem happens at boot time (so don't have the message
readily available). I will write it down after work tonight and report
a bug as you suggested.

-t
