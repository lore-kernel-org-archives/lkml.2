Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2CaVkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:40:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53791 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2CaVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:40:07 -0400
Message-ID: <4F77795C.6050109@mvista.com>
Date: Sun, 01 Apr 2012 01:38:36 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        olof@lixom.net, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] ARM: at91: include newly created system_misc.h file
References: <cover.1333026637.git.nicolas.ferre@atmel.com> <1333110669-24554-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1333110669-24554-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 30-03-2012 16:31, Nicolas Ferre wrote:

> system.h file has been split by commit "0195c00".

    Please also specify that commit's summary in parens. And don't put commit 
ID into quoates.

> Now include
> system_misc.h for having access to arm_pm_restart.

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

WBR, Sergei

