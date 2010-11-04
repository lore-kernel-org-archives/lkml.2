Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0KDAes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 20:34:48 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:36462 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917Ab0KDAer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 20:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <1288827394-7505-1-git-send-email-rene.sapiens@ti.com>
References: <1288827394-7505-1-git-send-email-rene.sapiens@ti.com>
Date: Wed, 3 Nov 2010 18:34:44 -0600
Message-ID: <AANLkTikAS0oHpGLYesoXa8YMpOwV4e8M3f7ZEhbrm4b9@mail.gmail.com>
Subject: Re: [PATCH 1/8] staging: tidspbridge: overwrite DSP error codes
From: "Sapiens, Rene" <rene.sapiens@ti.com>
To: greg@kroah.com
Cc: gregkh@suse.de, nm@ti.com, felipe.contreras@gmail.com, ernesto@ti.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, Rene Sapiens <rene.sapiens@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 5:36 PM, Rene Sapiens <rene.sapiens@ti.com> wrote:
> When calling the DSP's remote functions, the DSP returns error
> codes different from the ones managed by the kernel, the
> function's return value is shared with the MPU using a shared
> structure. This patch overwrites those error codes by kernel
> specifics and deletes unnecessary code.
>

The series of patches that follow this one do not apply yet, so please omit this
patch, i will send it again as a single one.

Regards,
Rene
