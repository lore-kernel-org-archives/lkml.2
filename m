Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1GWAbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:31:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34833 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1GWAbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:31:05 -0400
Message-ID: <4E2A1642.6000900@canonical.com>
Date: Fri, 22 Jul 2011 17:30:58 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: djkurtz@chromium.org
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 1/9 v2] Input: synaptics - refactor y inversion
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org> <1311169146-20066-2-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1311169146-20066-2-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 06:38 AM, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Synaptics touchpads report increasing y from bottom to top.
> This is inverted from normal userspace "top of screen is 0" coordinates.
> Thus, the kernel driver reports inverted y coordinates to userspace.
> 
> This patch refactors this inversion.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Acked-by: Chase Douglas <chase.douglas@canonical.com>
