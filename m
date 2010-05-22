Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0EVX4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 19:56:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58819 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0EVX4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 19:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YrZUd8L162M7pd7uxsGCp9z+zrvoA2J5GUx249a3bXzj5dvUdHi3o3F/ajMHR4Aqb5
         C/6NEP13p3+6cuI2is51tf63K//MuHVBdBrfGcbo35ccojUYQ7im3lI+inYpD/I/+hIg
         HF8Hs3AsmX6sCIJFsl/inwUQbLbnYpWo2Dw3w=
Date: Sat, 22 May 2010 16:53:32 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: =?utf-8?B?0KLQuNC80L7RhNC10Lkg0KLRgNC+0YTQuNC80L7Qsg==?= 
	<tumoxep@gmail.com>
Cc: gregkh@suse.de, lieb@canonical.com, more.andres@gmail.com,
       forest@alittletooquiet.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: fix brace coding style issue in
 80211mgr.c This is a patch to the 80211mgr.c file that fixes up a brace
 warning found by the checkpatch.pl tool Signed-off-by: Timofey Trofimov
 <tumoxep@gmail.com>
Message-ID: <20100522235331.GA27828@fujitsu>
References: <1274546574-8338-1-git-send-email-tumoxep@gmail.com>
 <20100522173510.GA26310@fujitsu>
 <AANLkTilS9UjF6jbsqtsZBlTkv_s4ayfu5GfW5_51tOzT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilS9UjF6jbsqtsZBlTkv_s4ayfu5GfW5_51tOzT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, May 22, 2010 at 09:52:25PM +0400, Тимофей Трофимов wrote:
> Hi, Charles. I understand what I did wrong and never will make this
> mistake  mistake again. I really thought that I write this. Sorry.
> P.S. This is my first patch. Does I need to resend it?

I think you should try to resend it, at least to get the subject line
and body correct, you can try that by sending it only to yourself first.

I should also point out that the discussion should remain on the
corresponding mailing lists.

-- 
Charles Clément

