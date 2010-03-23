Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0CWLDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:03:15 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59569 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0CWLDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LEqLDIeheL/UxLfcduKgrOnbqwB0jMvZ6HRNNjO7+QS6SNI75g/jmVfxd7A6vyC9Ho
         qG14EDOSuhtoPFjCsBEheVaIbmYD5LYbSJbIl33i3YDT1hS1ksrPY/mMwuiUd0rdHV8s
         WxuYUF7cua3NVVXQ8+LV/Tn+ToBppxdERbkws=
Date: Tue, 23 Mar 2010 14:03:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Cc: gregkh@suse.de, mchehab@redhat.com, palash.bandyopadhyay@conexant.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: cx25821: fix coding style issues in
	cx25821-medusa-video.c
Message-ID: <20100323110259.GV21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Olimpiu Pascariu <olimpiu.pascariu@gmail.com>, gregkh@suse.de,
	mchehab@redhat.com, palash.bandyopadhyay@conexant.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <1269197503.6971.11.camel@tuxtm-linux> <20100322133513.GO21571@bicker> <1269288630.6365.1.camel@tuxtm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269288630.6365.1.camel@tuxtm-linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 10:10:30PM +0200, Olimpiu Pascariu wrote:
> >From 32591165a537a03f472c68289798044d6eeea2e0 Mon Sep 17 00:00:00 2001
> From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
> Date: Mon, 22 Mar 2010 22:07:20 +0200
> Subject: [PATCH 5/5] Staging: cx25821: fix coding style issues in cx25821-medusa-video.c
>  This is a patch to cx25821-medusa-video.c file that fixes up warnings and errors found by the checkpatch.pl tool
>  Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

	[snip]

> +		/*
> +		 * clear VPRES_VERT_EN bit, fixes the chroma run away problem
> +		 * when the input switching rate < 16 fields
> +		*/
               ^^^
	Missing a space here.

Otherwise looks good.

Acked-by: Dan Carpenter <error27@gmail.com>

regard,
dan carpenter
 
