Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1AYMYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:24:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55050 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1AYMYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=AkaM4ufjLTeEHMs+3h3hIErqyq1Y+5Vl1tmOR4zyaSe6UH8TNvDYU6gaHVNbN2L0YL
         ibFA3MWYFMZ3hpKI4qo8KivxLYAswranTk4OOaM6Xga3KfZsx/0i/3YZn3HYZyFsDxfD
         oKsLga7PnZFnohlWvkD3Fz7Cly/33U4FttxkY=
Date: Tue, 25 Jan 2011 15:23:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 07/12] staging: ft1000: Fix coding style in
 get_request_type() function.
Message-ID: <20110125122343.GE2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
 <1295955083-11086-7-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295955083-11086-7-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:31:18PM +0100, Marek Belisko wrote:
>  static u16 get_request_type(struct ft1000_device *ft1000dev)
>  {
> -   u16   request_type;
> -   u32    status;
> -   u16   tempword;
> -   u32    tempx;
> +	u16   request_type;
> +	u32    status;
> +	u16   tempword;
> +	u32    tempx;
              ^^
The alignment is sort of whacky looking.

regards,
dan carpenter


