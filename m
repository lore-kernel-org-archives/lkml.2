Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab1IMJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 05:25:26 -0400
Received: from mail2.vodafone.ie ([213.233.128.44]:34610 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1IMJZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 05:25:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAFsgb05tTinB/2dsb2JhbAAMNqozAQEFMgFGEAsNAQoJFg8JAwIBAgFFBg0BBQIBAb5Zhm4EmHWDE4hY
Message-ID: <4E6F2182.4040808@draigBrady.com>
Date: Tue, 13 Sep 2011 10:25:22 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Greg Lee <glee@swspec.com>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add WDIOC_GETTIMELEFT ioctl support to w83627 watchdog
 driver
References: <CADB-PD3bJEHPTa8RXP-RjHZHsFXyFUVosOPh7kUgUEWOQDr3qA@mail.gmail.com>
In-Reply-To: <CADB-PD3bJEHPTa8RXP-RjHZHsFXyFUVosOPh7kUgUEWOQDr3qA@mail.gmail.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 01:28 AM, Greg Lee wrote:
> Add WDIOC_GETTIMELEFT ioctl allowing you to check how much time is left
> on the watchdog counter before a reset occurs.  A few additional
> naming clean-ups
> requested by Padraig Brady as well.
> 
> Signed-off-by: Greg Lee <glee [at] swspec.com>

Acked-by: Pádraig Brady <P@draigBrady.com>
