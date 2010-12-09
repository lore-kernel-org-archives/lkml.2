Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0LIInv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:43:51 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:62379 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab0LIInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:43:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oXpoXYrc0oyzlTErcFQq0ZbPL2j18Pbabl0FEcAdUHRgUGguETQduzmD0ZzU07wtDc
         2r0YzWHfMyjg4h1BrEFDhHjWh9JtCypzgjWNsTgBF60RNJlrA7sjfxkJ8W8wi0Zytph+
         jSysnXnwuJ78+Pi5kfjTwS6bTweHD9auHJvok=
Date: Thu, 9 Dec 2010 10:43:44 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: format and standards issues fixes
Message-ID: <20101209084344.GA4987@core2.telecom.by>
References: <20101209073126.GA2212@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209073126.GA2212@debian.Jeff>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 01:01:26PM +0530, Jeffrin Jose wrote:
> @@ -152,15 +151,14 @@ extern int msnd_pinnacle_init(void);
>  #ifdef CONFIG_SOUND_OSS_CORE_PRECLAIM
>  static int preclaim_oss = 1;
>  #else
> -static int preclaim_oss = 0;
> +static int preclaim_oss = -1;

You didn't understand that warning, do you?

> @@ -252,8 +248,9 @@ static DEFINE_SPINLOCK(sound_loader_lock);
>   *	list. Acquires locks as needed
>   */
>  
> -static int sound_insert_unit(struct sound_unit **list, const struct file_operations *fops, int index, int low, int top, const char *name, umode_t mode, struct device *dev)
> -{
> +static int sound_insert_unit(struct sound_unit **list, const struct \
> +file_operations *fops, int index, int low, int top, const char *name,\
> +umode_t mode, struct device *dev) {

You're splitting lines in unexpected places, so unexpected, that nobody
thought of them before.
