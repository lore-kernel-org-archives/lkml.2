Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1APOHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 09:07:03 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13263 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1APOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 09:07:01 -0500
Date: Sun, 16 Jan 2011 15:07:00 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tony Finch <dot@dotat.at>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] strncpy() will not \0 terminate result
In-Reply-To: <0203A9B5-3035-49A1-AAB7-207EB638A080@dotat.at>
Message-ID: <alpine.LNX.2.00.1101161506300.8049@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132332430.11347@swampdragon.chaosbits.net> <0203A9B5-3035-49A1-AAB7-207EB638A080@dotat.at>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Tony Finch wrote:

> This patch is incorrect. The strncpy is replacing "else" with "if  " so needs to copy exactly 4 bytes.
> 
Whoops. Sorry about the noise.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

