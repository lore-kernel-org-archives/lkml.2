Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0CRROK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:14:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34760 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CRROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:14:05 -0400
Message-ID: <4BA25499.8070505@cs.helsinki.fi>
Date: Thu, 18 Mar 2010 18:28:09 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlme_s.h Coding style fixes
References: <1268927106-12321-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1268927106-12321-1-git-send-email-lindley@coyote.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley wrote:
> I fixed all problems found by checkpatch.pl except typedefs.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

This is probably going to conflict with my typedef removal patches but 
there's no much we can do until Greg merges the patches.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
