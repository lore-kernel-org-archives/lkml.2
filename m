Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab0JFNpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:45:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33984 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab0JFNpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kRRMLHY3hbwkblYJheraf0FI0s0bbI2Zz9eo54c9JcHhiO3TeWtR0L9cyR0bjSDZPF
         kXQKN4y0QcBUrlj0Bx2GLYMfH0cwYgvpvGpticMG2qEmn9wtknLzGLG32CZuGOz0uwKy
         LIIgyIa4XuEUuvruMSTkaikM2SRDLLh774/7M=
Date: Wed, 6 Oct 2010 17:45:39 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: matt mooney <mfm@muteddisk.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] power: makefile cleanup
Message-ID: <20101006134539.GA16839@oksana.dev.rtsoft.ru>
References: <1286351187-24245-1-git-send-email-mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1286351187-24245-1-git-send-email-mfm@muteddisk.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:46:27AM -0700, matt mooney wrote:
> Replace EXTRA_CFLAGS with ccflags-y; remove if-statements and replace
> with lists using the kbuild idiom.
> 
> None of the dependencies are modified.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
