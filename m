Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab0FGNRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:17:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:29494 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0FGNRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinrRP_GYZiFRv_WzLnS_XGc9f0n-4V9GfZ-WVBQ@mail.gmail.com>
References: <AANLkTikgWif5ACj4Zm_4eFbx5cAipxMHd5vR4wcYePEZ@mail.gmail.com> 
	<AANLkTinrRP_GYZiFRv_WzLnS_XGc9f0n-4V9GfZ-WVBQ@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 7 Jun 2010 15:16:39 +0200
Message-ID: <AANLkTilLoVi_iGKadGHhmFKiZZPZUHJ7BrkfNBHy6YBi@mail.gmail.com>
Subject: Re: Unable to boot after "ACPI: Don't let acpi_pad needlessly mark 
	TSC unstable"
To: Venkatesh Pallipadi <venki@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Chen Gong <gong.chen@linux.intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 5:33 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> If you can provide some addittional info above and 'dmesg'  from no
> error case (with this revert) and put them all in a bug at
> bugzilla.kernel.org under ACPI, it will be great.

Created report: <https://bugzilla.kernel.org/show_bug.cgi?id=16145>.

-t
