Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0LGGbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:31:50 -0500
Received: from freeflow.nu ([178.79.134.28]:42371 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab0LGGbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:31:49 -0500
Message-ID: <4CFDD4D8.10403@kernel.org>
Date: Tue, 07 Dec 2010 08:31:52 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/6] Staging: w35und: Merge wbhal_f.h to wbhal_s.h
References: <1291454177-5102-1-git-send-email-penberg@kernel.org> <20101207001253.GA20030@kroah.com>
In-Reply-To: <20101207001253.GA20030@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/10 2:12 AM, Greg KH wrote:
> On Sat, Dec 04, 2010 at 11:16:12AM +0200, Pekka Enberg wrote:
>> This patch merges HAL struct and function definitions into one header file.
> This patch doesn't apply at all, what was it made against?

They're actually patches that predate the ones you merged recently from 
me. I just pulled your tree to mine and did "git format-patch" without 
thinking about it too much.

> Care to refresh this whole series so it can be applied?

Sure, I can do that.

             Pekka
