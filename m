Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1BAFdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 00:33:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52493 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1BAFde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 00:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Dv30Ss+Ud4hqbxOdseiNV8rRbpWMYNmsJ4pS7Y6taXbW3Msx6dyjIGromJFLf6cBb/
         8B3cXRdsreIazuzZEsD3PL5ycYihhLbm4reUPj7uMe+kFqSfR53tGON0NgLndI0oOt8L
         CrMxW+S5uDy9a3R8JJ87j+oQH8k18E1j4WFRk=
Date: Tue, 1 Feb 2011 08:33:06 +0300
From: Dan Carpenter <error27@gmail.com>
To: Timo von Holtz <tvh@informatik.uni-kiel.de>
Cc: gregkh@suse.de, shemminger@vyatta.com, arnd@arndb.de, jj@chaosbits.net,
        joe@perches.com, eric.dumazet@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: fixed coding style issues
Message-ID: <20110201053306.GG20606@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Timo von Holtz <tvh@informatik.uni-kiel.de>, gregkh@suse.de,
	shemminger@vyatta.com, arnd@arndb.de, jj@chaosbits.net,
	joe@perches.com, eric.dumazet@gmail.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1296525024-21898-1-git-send-email-tvh@informatik.uni-kiel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296525024-21898-1-git-send-email-tvh@informatik.uni-kiel.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 02:50:24AM +0100, Timo von Holtz wrote:
>  static struct file_operations bcm_fops = {
>  	.owner    = THIS_MODULE,
> -	.open     = bcm_char_open,
> +	.open     = bcm_char_open,,
                                 ^^
Only one comma needed.

>  	.release  = bcm_char_release,
>  	.read     = bcm_char_read,

regards,
dan carpenter


