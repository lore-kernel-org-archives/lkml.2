Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0LFIxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:53:41 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:48477 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab0LFIxk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:53:40 -0500
MIME-Version: 1.0
In-Reply-To: <1288830684-7828-1-git-send-email-rene.sapiens@ti.com>
References: <1288830684-7828-1-git-send-email-rene.sapiens@ti.com>
Date: Mon, 6 Dec 2010 02:53:39 -0600
Message-ID: <AANLkTikxrXXW-M7EJ1aWiuyHg1un4+cTo8=Cb4DqiYk+@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: overwrite DSP error codes
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Rene Sapiens <rene.sapiens@ti.com>
Cc: greg@kroah.com, gregkh@suse.de, nm@ti.com, felipe.contreras@gmail.com,
        ernesto@ti.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 7:31 PM, Rene Sapiens <rene.sapiens@ti.com> wrote:
> When calling the DSP's remote functions, the DSP returns error
> codes different from the ones managed by the kernel, the
> function's return value is shared with the MPU using a shared
> structure. This patch overwrites those error codes by kernel
> specifics and deletes unnecessary code.
>
> Signed-off-by: Rene Sapiens <rene.sapiens@ti.com>
> ---
>  drivers/staging/tidspbridge/rmgr/disp.c |   44 +++++-------------------------
>  1 files changed, 8 insertions(+), 36 deletions(-)

Pushed to dspbridge.

Regards,

Omar
