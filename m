Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2HADAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 23:00:17 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:56726 "EHLO
	homiemail-a83.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752676Ab2HADAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 23:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=mime-version
	:content-type:content-transfer-encoding:date:from:to:subject
	:in-reply-to:references:message-id; q=dns; s=shealevy.com; b=YCw
	rcGKK7yA6VVhLCWxBOklZdKoHWtYKGG/W09bjhSD1FaWpRfkx0zpeyqSkJnC4ZGR
	xD0UufUhJ/QjLV07K51IJD00xp9SuWWTNtMFqsbGBTw/5Hdno2USojs3GeBiIL5J
	XimkBghoRnp8O9uxAYCEsGDZUY5Sp67jvmEBubqg=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2012 23:00:14 -0400
From: shea@shealevy.com
To: <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix firmware installation for images w/o subdirs
In-Reply-To: <663f65e29cc718b63ef0e2a769d03606@shealevy.com>
References: <663f65e29cc718b63ef0e2a769d03606@shealevy.com>
Message-ID: <da6d59384139a520b703d84d1be2ac92@shealevy.com>
User-Agent: RoundCube Webmail/0.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.2012 22:59, shea@shealevy.com wrote:
> On some setups (probably due to too new a GNU Make), firmware
> installation fails with
> *** No rule to make target `lib/firmware/./', needed by
> `lib/firmware/<file>.fw'.  Stop.
> when a file in the top-level firmware/ directory is needed.
>
> Original patch idea by Denys Dmytriyenko, see
> http://permalink.gmane.org/gmane.linux.embedded.yocto.meta-ti/27
>
> Signed-off-by: Shea Levy <shea@shealevy.com>
> ---
>  scripts/Makefile.fwinst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Whoops, sorry for the double post.
