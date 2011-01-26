Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1AZNnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:43:37 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50066 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1AZNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:43:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kReTwa9nEAt+y/7dEZ22DXQ59qh4/K/LshUaZTb7L0K5eMzYJMJaoymQ79JRh4kR6P
         BH9vYBFiM7U+H1uq9kuvnPVGh2aBC/W3av80gh7Wb+wnPrYMX6UQyB81PzLn8gE697XH
         FLeTumocOMqBbPNKjI1r9kya9h/1qSPanBx2I=
Date: Wed, 26 Jan 2011 16:43:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in
 write_blk_fifo() function.
Message-ID: <20110126134318.GO2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
 <1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
 <20110126130718.GN2721@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126130718.GN2721@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 04:07:18PM +0300, Dan Carpenter wrote:
> You didn't introduce it but do you know what the code is trying to do
> here?
> 
>         byte_length = word_length * 4;
> 
>         if (byte_length % 4)

Actually this check is pointless.  word_length * 4 is always
aligned at 4 bytes.

regards,
dan carpenter


