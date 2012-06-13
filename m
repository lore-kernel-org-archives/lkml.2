Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2FMPW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:22:29 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:49318 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab2FMPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:22:28 -0400
Message-ID: <4FD8A873.40909@stericsson.com>
Date: Wed, 13 Jun 2012 16:49:23 +0200
From: =?ISO-8859-1?Q?Aur=E9lien_G=E9rault?= 
	<aurelien.gerault-xsig@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111110 Thunderbird/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk: Ensure oops printing if console is locked
References: <1339578852-17617-1-git-send-email-aurelien.gerault-xsig@stericsson.com> <20120613141157.GB11538@kroah.com>
In-Reply-To: <20120613141157.GB11538@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh yes, sorry about that, will upload a new patch soon.

On 06/13/2012 04:11 PM, Greg Kroah-Hartman wrote:
> What are those fields for?
>
>> Change-Id: I9f571492fefc32291ecd0cc62f0ad7031cab7c6d
> What is this for?
>
> Please clean up the patch before sending it out publicly, we can't take
> stuff like this...
>
