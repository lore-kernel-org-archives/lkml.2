Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0C1PiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 11:38:23 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43369 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0C1PiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 11:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=hzglrk3wD9cGaPweBinuTTB3lR8df8WMaL/5/x0Pwe3O9lpLTxYcRVzpu5JdhA2PBB
         J6FPLaSCyRXko5E8HIbMjPD1O8Ms35KOKJ5AbRG0KAs+rLnjpJQS6OHEmbVnORRfg+47
         TBoTqrf6Zfg8oP8ZhAbBF6B/CZb5Mi4XNRUng=
Date: Sun, 28 Mar 2010 18:38:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] video/sn9c102: improve error handling
Message-ID: <20100328153810.GA5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100328115005.GW5069@bicker> <honrg5$7uk$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <honrg5$7uk$1@dough.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 05:09:48PM +0200, Christophe JAILLET wrote:
> Hi,
> 
> this patch seems incomplete.
> 
> You had an opening { wityhout the corresponding }.

It must be an issue with the mail server on your end. :/ 

Here is a url you can download it from.
http://lkml.org/lkml/2010/3/28/43

Unfortunately, lkml.org puts some white space on the end of diffs.
Patch complains but it still applies them fine.

regards,
dan carpenter


