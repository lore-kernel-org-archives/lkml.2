Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1JQHw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:52:56 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:54846 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1JQHwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:52:54 -0400
Subject: Re: [PATCH 12/21] m68k: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E9B7BE1.1080907@snapgear.com>
References: <1318595371.6132.70.camel@x61.thuisdomein>
	 <4E9B7BE1.1080907@snapgear.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 09:52:44 +0200
Message-ID: <1318837964.6414.6.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 10:50 +1000, Greg Ungerer wrote:
> I have no problem with the changes. But it will clash with the
> reworking of the Kconfig files currently sitting in linux-next
> for merging in the 3.2 merge window.

So should I put this on hold and see what's needed after those reworked
Kconfig files are merged in mainline? Or would you prefer to have that
done beforehand (ie, I'll try to redo this on top of current linux-next
and get the redone patch in linux-next before the 3.2 merge)?


Paul Bolle

