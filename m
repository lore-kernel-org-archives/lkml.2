Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2BEA1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:27:30 -0500
Received: from void.printf.net ([89.145.121.20]:41760 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab2BEA12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:27:28 -0500
From: Chris Ball <cjb@laptop.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v4 0/2] mmc: core: Support packed command feature of eMMC4.5
References: <000901ccdc09$92daf020$b890d060$%jun@samsung.com>
Date: Sat, 04 Feb 2012 19:27:17 -0500
In-Reply-To: <000901ccdc09$92daf020$b890d060$%jun@samsung.com> (Seungwon
	Jeon's message of "Thu, 26 Jan 2012 18:04:56 +0900")
Message-ID: <m2obte86qi.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seungwon,

On Thu, Jan 26 2012, Seungwon Jeon wrote:
> This patch-set adds support of packed command feature
> for eMMC4.5 devices.

Thanks, looks good!  Were you or Namjae able to measure any performance
changes with this patchset applied?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
