Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab1BSKzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 05:55:18 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:55090 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab1BSKzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 05:55:15 -0500
Message-ID: <4D5FA185.1040008@free.fr>
Date: Sat, 19 Feb 2011 11:55:01 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: xemul@parallels.com, containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/9] allow killing tasks in your own or child userns
References: <20110217150224.GA26334@mail.hallyn.com> <20110217150325.GD26395@mail.hallyn.com>
In-Reply-To: <20110217150325.GD26395@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 04:03 PM, Serge E. Hallyn wrote:
> Changelog:
> 	Dec  8: Fixed bug in my check_kill_permission pointed out by
> 	        Eric Biederman.
> 	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
> 	        for clarity
> 	Dec 31: address comment by Eric Biederman:
> 		don't need cred/tcred in check_kill_permission.
> 	Jan  1: use const cred struct.
> 	Jan 11: Per Bastian Blank's advice, clean up kill_ok_by_cred().
> 	Feb 16: kill_ok_by_cred: fix bad parentheses
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
