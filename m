Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2EMT2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 15:28:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20516 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2EMT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 15:28:33 -0400
Date: Sun, 13 May 2012 22:31:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: my84@bk.ru, devel@driverdev.osuosl.org, hverkuil@xs4all.nl,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mchehab@infradead.org, dhowells@redhat.com, justinmattock@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: media: go7007: Adlink MPG24 board
Message-ID: <20120513193152.GF16984@mwanda>
References: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
 <1336935162-5068-2-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336935162-5068-2-git-send-email-volokh84@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 10:52:42PM +0400, Volokh Konstantin wrote:
> Changes:
>     - wis-tw2804.ko module code was incompatible with 3.4 branch in initialization v4l2_subdev parts. now i2c_get_clientdata(...) contains v4l2_subdev struct instead non standard wis_tw2804 struct
>     - Use V4L2 control framework
> 
> Adds:
>   - Additional chipset tw2804 controls with: gain,auto gain,inputs[0,1],color kill,chroma gain,gain balances, for all 4 channels (from tw2804.pdf)
>   - Power control for each 4 ADC (tw2804) up when s_stream(...,1), down otherwise
> 

This patch as well has a lot of good stuff in it, but it needs to
be broken up.

regards,
dan carpenter

