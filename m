Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1JJGzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:55:15 -0400
Received: from bitmer.com ([213.157.87.50]:47008 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab1JJGzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:55:11 -0400
Message-ID: <4E9296A2.50003@bitmer.com>
Date: Mon, 10 Oct 2011 09:54:26 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111005 Icedove/3.1.15
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@linaro.org>
CC: lrg@ti.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de, linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] omap: sound: fix "ambiguous else" warning
References: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org> <1318223228-15671-2-git-send-email-michael.opdenacker@linaro.org>
In-Reply-To: <1318223228-15671-2-git-send-email-michael.opdenacker@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 10/10/2011 08:07 AM, Michael Opdenacker wrote:
> This patch applies against Tony Lindgren's linux-omap tree
> It fixes "ambiguous else" warnings at compile time.
>
> Signed-off-by: Michael Opdenacker<michael.opdenacker@linaro.org>
> ---
>   sound/soc/omap/omap-mcbsp.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
This is already fixed in ASoC tree by following commit

commit 141947e6ceb8f82fe8382b26f093bb379af9af15
Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
Date:   Mon Sep 26 10:56:42 2011 +0300

     ASoC: omap-mcbsp: Fix compile time warning about ambiguous ‘else’


-- 
Jarkko
