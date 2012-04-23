Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2DWRnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:43:47 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3346 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab2DWRnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:43:42 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4F9594C1.5060000@broadcom.com>
Date: Mon, 23 Apr 2012 10:43:29 -0700
From: "Franky Lin" <frankyl@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310
 Thunderbird/11.0
MIME-Version: 1.0
To: "Eldad Zack" <eldad@fogrefinery.com>,
        "John W. Linville" <linville@tuxdriver.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Arend van Spriel" <arend@broadcom.com>,
        "Kan Yan" <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [brcmsmac] "INTERMEDIATE but not AMPDU" only when
 tracing
References: <1335048484-5925-1-git-send-email-eldad@fogrefinery.com>
In-Reply-To: <1335048484-5925-1-git-send-email-eldad@fogrefinery.com>
X-WSS-ID: 638B4B423IO9025608-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 03:48 PM, Eldad Zack wrote:
>  From the code comment I understand that this something that can - and does, quite frequently - happen.
> This patch demotes the message to the trace level.
>
> Signed-off-by: Eldad Zack<eldad@fogrefinery.com>

Thx Eldad,

Acked-by: Franky Lin<frankyl@broadcom.com>

