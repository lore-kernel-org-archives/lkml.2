Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2BOTOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:14:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61568 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2BOTOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:14:45 -0500
Message-ID: <4F3C0421.20506@lwfinger.net>
Date: Wed, 15 Feb 2012 13:14:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Tim Gardner <tim.gardner@canonical.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtlwifi: rtl8192se firmware load can overflow target
 buffer
References: <1328833192-10681-1-git-send-email-Larry.Finger@lwfinger.net> <20120215185525.GE4379@tuxdriver.com>
In-Reply-To: <20120215185525.GE4379@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 12:55 PM, John W. Linville wrote:
> Is this a fix that should go to 3.3?

That code has been in the driver since 3.0 and it should probably be packported. 
On the other hand, Tim's report is the first one. My suggestion is that it go 
into 3.4.

In addition, I am working on a fix that will completely eliminate all this fixed 
storage.

Larry


