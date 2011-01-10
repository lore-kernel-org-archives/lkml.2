Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1AJWzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:55:19 -0500
Received: from xenotime.net ([72.52.115.56]:45850 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755085Ab1AJWzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:55:15 -0500
Message-ID: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
In-Reply-To: <1294699587-2362-1-git-send-email-mikew@google.com>
References: <1294699587-2362-1-git-send-email-mikew@google.com>
Date: Mon, 10 Jan 2011 14:55:12 -0800 (PST)
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Mike Waychison" <mikew@google.com>
Cc: mingo@elte.hu, borislav.petkov@amd.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mikew@google.com
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, January 10, 2011 2:46 pm, Mike Waychison wrote:
> This patch applies to v2.6.37.
> ---
>
>
> On our systems, we do not want to have any "decoders" called on machine
> check events.  These decoders can easily spam our logs and cause space
> problems on machines that have a lot of correctable error events.  We _do_
> however want to get the messages delivered via /dev/mcelog for userland
> processing.
>
> Introduce an interface "dont_decode" that allows us to skip the
> decoders.  We always call the decoders by default.
>
> Google-Bug-Id: 3289142
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
> arch/x86/kernel/cpu/mcheck/mce.c |   24 ++++++++++++++++++------ 1 files
> changed, 18 insertions(+), 6 deletions(-)


Hi,

Please update Documentation/x86/x86_64/boot-options.txt
with this new option.

-- 
~Randy

