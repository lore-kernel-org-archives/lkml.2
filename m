Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0CUMlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 08:41:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49116 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0CUMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 08:40:59 -0400
Message-ID: <4BA613C7.5030600@cs.helsinki.fi>
Date: Sun, 21 Mar 2010 14:40:39 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Sankar P <sankar.curiosity@gmail.com>
CC: gregkh@suse.de, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: winbond: Cleanups
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
In-Reply-To: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sankar P wrote:
> The following series of patches are cleanups on the winbond driver
> under staging. Some typedefs are converted to structs and
> an un-used enumeration and a typedef are removed. 

Well, there's an identical patch series by me floating around waiting 
for Greg to apply them. But should Greg go with these, they look good to 
me except for the fixed point one for which we have a better patch also 
waiting to be applied.

			Pekka
