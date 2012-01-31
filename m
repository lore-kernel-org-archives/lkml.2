Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2AaGWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:22:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34999 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2AaGWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:22:22 -0500
MIME-Version: 1.0
In-Reply-To: <1327967103.4230.7.camel@joe2Laptop>
References: <1327927591-28070-1-git-send-email-devendra.aaru@gmail.com>
	<4F27294D.30302@lwfinger.net>
	<1327967103.4230.7.camel@joe2Laptop>
Date: Tue, 31 Jan 2012 01:22:22 -0500
Message-ID: <CAHdPZaPFq0eB2Y7zogr_xh+Ct0Ot4S+sU9RQSDquo5_Z=C+R8Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] wireless: remove return in _rtl_pci_switch_clk_req
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, chaoming_li@realsil.com.cn,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 6:45 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-01-30 at 17:35 -0600, Larry Finger wrote:
>> The patch is OK, but the patch subject is bad. You should have "[PATCH]
>> rtlwifi:...". Your patch is for rtlwifi, not wireless.
>
Will post a new patch, Thanks !!
> Hi Devendra.
>
> A reasonable rule of thumb is use the deepest directory
> path basename you can to prefix the patch.
> Something like:
>
> [PATCH] $(basename $(dirname $file)): terse description
>
> If you are patching drivers/net/ethernet/realtek/apt.c
> this becomes:
>
> [PATCH] realtek: terse description
>
> There are some exceptions though.  One of them
> is if the patch is in staging, prefix with
> [PATCH] staging: $(basename $(dirname $file)): description
>
> cheers, Joe
>
Thanks a lot Joe, will follow your suggestions :).

Devendra.
