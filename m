Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769Ab2JXNWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:22:43 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:52386 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2JXNWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:22:42 -0400
Date: Wed, 24 Oct 2012 11:22:34 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next] bluetooth: hci_core: Replace
 list_for_each with list_for_each_entry() helper
Message-ID: <20121024132234.GG13884@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Denis Kirjanov <kirjanov@gmail.com>, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1350912121-24171-1-git-send-email-kirjanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350912121-24171-1-git-send-email-kirjanov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

* Denis Kirjanov <kirjanov@gmail.com> [2012-10-22 17:22:01 +0400]:

> Replace list_for_each with list_for_each_entry() helper
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> ---
>  include/net/bluetooth/hci_core.h |   20 ++++++++------------
>  1 files changed, 8 insertions(+), 12 deletions(-)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
