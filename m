Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2GXRlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:41:23 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:56120 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab2GXRlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <1342860960-19463-1-git-send-email-develkernel412222@gmail.com>
References: <1342860960-19463-1-git-send-email-develkernel412222@gmail.com>
Date: Tue, 24 Jul 2012 12:41:20 -0500
Message-ID: <CAB-zwWha-jRv-usqvkrRCBqLqajgr8VAh66BVBtSDRK9S1BBcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging/tidspbridge: use module_platform_driver
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?V=EDctor_Manuel_J=E1quez_Leal?= <vjaquez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 3:56 AM, Devendra Naga
<develkernel412222@gmail.com> wrote:
> the code under _init and _exit does platform_driver_register and
> platform_driver_unregister respectively only,
>
> so its better to use the module_platform_driver than just replicating
> the module_platform_driver's implementation
>
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>

FWIW, looks good to me.

Cheers,

Omar
