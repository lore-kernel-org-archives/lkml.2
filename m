Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HOJpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 05:45:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37811 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1HOJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 05:45:42 -0400
Message-ID: <4E48EAA0.5020901@mvista.com>
Date: Mon, 15 Aug 2011 13:45:04 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 02/11] arch/mips: do not use EXTRA_CFLAGS
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com> <1313384834-24433-3-git-send-email-lacombar@gmail.com>
In-Reply-To: <1313384834-24433-3-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-08-2011 9:07, Arnaud Lacombe wrote:

> Usage of these flags has been deprecated for nearly 4 years by:

>      commit f77bf01425b11947eeb3b5b54685212c302741b8
>      Author: Sam Ravnborg<sam@neptun.(none)>
>      Date:   Mon Oct 15 22:25:06 2007 +0200

>          kbuild: introduce ccflags-y, asflags-y and ldflags-y

> Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
> line use. By default, gmake(1) do not override command line setting, so this is
> likely to result in build failure or unexpected behavior.

> Replace their usage by Kbuild's `{as,cc,ld}flags-y'.

> Cc: Sam Ravnborg<sam@ravnborg.org>
> Cc: linux-mips@linux-mips.org

    You didn't sign off.

WBR, Sergei
