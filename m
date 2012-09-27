Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2I0SCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:02:02 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45309 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2I0SCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:02:00 -0400
Message-ID: <50649491.4010100@suse.cz>
Date: Thu, 27 Sep 2012 20:01:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        gregkh@linuxfoundation.org, xemul@parallels.com
Subject: Re: [patch 2/2] tty: Add get- ioctls to fetch tty status v2
References: <20120927165958.287690622@openvz.org> <20120927170137.805935065@openvz.org> <506491C1.7060807@suse.cz> <20120927175830.GT6618@moon>
In-Reply-To: <20120927175830.GT6618@moon>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 07:58 PM, Cyrill Gorcunov wrote:
> Crap, for some reason cscope has not indexed them

make ALLSOURCE_ARCHS=all cscope
is needed if you want other than current ARCH.

-- 
js
suse labs
