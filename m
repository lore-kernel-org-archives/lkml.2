Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2JVRAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:00:49 -0400
Received: from senator.holtmann.net ([87.106.208.187]:38274 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab2JVRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:00:48 -0400
Message-ID: <1350925243.1785.24.camel@aeonflux>
Subject: Re: [PATCH RESEND net-next] bluetooth: hci_core: Replace
 list_for_each with list_for_each_entry() helper
From: Marcel Holtmann <marcel@holtmann.org>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2012 10:00:43 -0700
In-Reply-To: <1350912121-24171-1-git-send-email-kirjanov@gmail.com>
References: <1350912121-24171-1-git-send-email-kirjanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

> Replace list_for_each with list_for_each_entry() helper
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> ---
>  include/net/bluetooth/hci_core.h |   20 ++++++++------------
>  1 files changed, 8 insertions(+), 12 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


