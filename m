Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2B0Qf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:35:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60098 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2B0Qfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:35:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomasw@gmail.com designates 10.180.104.4 as permitted sender) smtp.mail=tomasw@gmail.com; dkim=pass header.i=tomasw@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330047536-3827-5-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
	<1330047536-3827-5-git-send-email-djpohly@gmail.com>
Date: Mon, 27 Feb 2012 18:35:54 +0200
X-Google-Sender-Auth: cve1Y23SIGyfeXcQs90XHeUmzwQ
Message-ID: <CA+i0qc57YGAxx10knr5vqinPn3shYKb_Rqwsd_qTdUftrvVZVw@mail.gmail.com>
Subject: Re: [PATCH 4/9] mei: return values are -Exxx, not ~Exxx!
From: Tomas Winkler <tomas.winkler@intel.com>
To: "Devin J. Pohly" <djpohly@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 3:38 AM, Devin J. Pohly <djpohly@gmail.com> wrote:
> From: "Devin J. Pohly" <djpohly@gmail.com>
>
> There's no way this is what was intended! :)
>
> Signed-off-by: Devin J. Pohly <djpohly@gmail.com>

Good catch but  can you please resend it out of  the series with maybe
some more informative commit message.

Appreciated
Tomas
