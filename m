Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2HFTcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:32:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39858 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494Ab2HFTcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:32:46 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.151.238]
In-Reply-To: <CAEvN+1h5dVxX74YtBNwjiqzZNrpK56jBw9TaJjszf_-E3DY2gw@mail.gmail.com>
References: <1344237865-32491-1-git-send-email-roylee17@gmail.com>
 <CAK=WgbbBHspN_LTUXH1kUugH8-Nr-G=p-G3Wj60tAmrqqfakmg@mail.gmail.com> <CAEvN+1h5dVxX74YtBNwjiqzZNrpK56jBw9TaJjszf_-E3DY2gw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 6 Aug 2012 22:32:25 +0300
Message-ID: <CAK=WgbbaRMf+-1cS8E+8eK-X=571-nO1ot1ywEP3=-homfMWhg@mail.gmail.com>
Subject: Re: [PATCH 1/1] remoteproc: extend customized fw loader to cover
 request and release
To: Tzu-Jung Lee <roylee17@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roy,

On Mon, Aug 6, 2012 at 7:43 PM, Tzu-Jung Lee <roylee17@gmail.com> wrote:
> That's what I'm trying to do, and it has two things needs to be address.
>
>   1)  Make the firmware loading step "optional" in the booting process.
>
>   2)  Allow the remoteproc use an customized handler to get the resource table.

Before we start digging into this, can you please tell which platform
are you working with ? is it upstream yet ?

Last we talked you couldn't yet disclose the platform identity. If
it's not upstream yet, we might prefer to postpone these discussions
until it is, to avoid unnecessary churn.

Thanks,
Ohad.
