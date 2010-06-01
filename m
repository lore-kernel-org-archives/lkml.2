Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0FAKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:25:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45571 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0FAKZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:25:55 -0400
Message-ID: <4C04E032.1020900@cs.helsinki.fi>
Date: Tue, 01 Jun 2010 13:25:54 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] zram: generic RAM based compressed R/W block devices
 (v2)
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/10 11:01 AM, Nitin Gupta wrote:
> Creates RAM based block devices: /dev/zramX (X = 0, 1, ...).
> Pages written to these disks are compressed and stored in memory
> itself. These disks allow very fast I/O and compression provides
> good amounts of memory savings.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
