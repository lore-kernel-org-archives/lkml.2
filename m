Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2EKG6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:58:35 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:49628 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752039Ab2EKG6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:58:33 -0400
Message-ID: <4FACB894.7000304@ti.com>
Date: Fri, 11 May 2012 09:58:28 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120509 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: dmitry.torokhov@gmail.com, broonie@opensource.wolfsonicro.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TWL6040: fix build error
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/10/2012 09:44 PM, Sasha Levin wrote:
> Fixes build error due to missing of_property_read_u32.

The reason I have not seen this is that I have CONFIG_OF_DEVICE selected
which will make the linux/of.h to be included in the linux/of_device.h

When I did sanity build check on x86 (64bit) I have not noticed any
breakage since the allmodconfig on 64bit does not build the
twl6040-vibra driver.

It is obvious that I need to improve my sanity kernel build testing.

> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
