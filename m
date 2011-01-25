Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1AYMP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:15:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1AYMPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:15:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=moecUo3LNedLw3qKoDaECLsSfMp0ZI8OtX6Q9BfSV0V5j9hdfW3SCAThgvVC5V9hV0
         4nli+vAPeQPnOtbf+GwNndOGt87L2yq1/JHJxsz8PcaEYpXj9ZAkRmLfPwWOT8Zrw7Tx
         AlVMA3i9FYUJCu8tDazMnzssjRjvpncwl//b0=
Date: Tue, 25 Jan 2011 15:14:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 05/12] staging: ft1000: Fix coding style in
 get_handshake_usb() function.
Message-ID: <20110125121453.GD2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
 <1295955083-11086-5-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295955083-11086-5-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:31:16PM +0100, Marek Belisko wrote:
>  static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value)
>  {
> -   u16            handshake;
> -   int               loopcnt;
> -   u16            temp;
> -   u32             status=0;
> +	u16 handshake, temp;

It's better to leave "handshake" and "temp" on seperate lines.  It's in
CodingStyle.

regards,
dan carpenter

