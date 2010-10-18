Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0JRSmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:42:43 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:48084 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0JRSml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:42:41 -0400
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 14:42:41 EDT
Message-ID: <4CBC8D4E.90008@grupopie.com>
Date: Mon, 18 Oct 2010 19:09:18 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/3] Use kasprintf
References: <1287341311-11161-1-git-send-email-julia@diku.dk>
In-Reply-To: <1287341311-11161-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> These patches convert a sequence of kmalloc and memcpy to use kasprintf
> instead.

Aren't these patches just a more convoluted way of doing a kstrdup?

I would imagine that a kasprintf would make more sense when the format
string is more complex than "%s", or am I missing something?

-- 
Paulo Marques - www.grupopie.com

"The face of a child can say it all, especially the
mouth part of the face."
