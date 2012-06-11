Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2FKPjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:39:22 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:46599 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2FKPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:39:20 -0400
Message-ID: <4FD61127.2070209@tilera.com>
Date: Mon, 11 Jun 2012 11:39:19 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: remove unused header
References: <1339357475.30984.49.camel@x61.thuisdomein>
In-Reply-To: <1339357475.30984.49.camel@x61.thuisdomein>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/2012 3:44 PM, Paul Bolle wrote:
> Nothing includes memprof.h. Nothing uses the macros it defines. It seems
> it is just a remnant of the proposed memprof functionality, which got
> dropped before the Tilera architecture got added to the tree. This
> header can safely be removed.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, I took this into the tile tree for 3.6.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



