Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab1IIHTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 03:19:01 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:58160 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab1IIHTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 03:19:00 -0400
Subject: Re: [PATCH 3/3] typedef cleanup
Mime-Version: 1.0 (Apple Message framework v1250.2)
Content-Type: text/plain; charset=us-ascii
From: Chris Boot <bootc@bootc.net>
In-Reply-To: <1315166085-27984-3-git-send-email-asido4@gmail.com>
Date: Thu, 8 Sep 2011 19:35:37 +0200
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A80909DB-416A-4E81-AEB9-1308366FC693@bootc.net>
References: <1315166085-27984-1-git-send-email-asido4@gmail.com> <1315166085-27984-3-git-send-email-asido4@gmail.com>
To: Arvydas Sidorenko <asido4@gmail.com>
X-Mailer: Apple Mail (2.1250.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Sep 2011, at 21:54, Arvydas Sidorenko wrote:

> #ifndef uint64_t
> -typedef struct _uint64_t {
> +struct _uint64_t {
> 	uint32_t low_dw;
> 	uint32_t hi_dw;
> } uint64_t;
> #endif

This can't be right can it? You're changing a typedef into a variable definition as far as I can see.

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net

