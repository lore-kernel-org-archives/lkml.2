Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab0GUVJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:09:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60493
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758234Ab0GUVJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:09:44 -0400
Date: Wed, 21 Jul 2010 14:10:00 -0700 (PDT)
Message-Id: <20100721.141000.150174979.davem@davemloft.net>
To: padovan@profusion.mobi
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] irda: Use __packed annotation instead IRDA_PACKED
 macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279745998-29694-1-git-send-email-padovan@profusion.mobi>
References: <1279745998-29694-1-git-send-email-padovan@profusion.mobi>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Gustavo F. Padovan" <padovan@profusion.mobi>
Date: Wed, 21 Jul 2010 17:59:57 -0300

> Remove IRDA_PACKED macro, which maps to __attribute__((packed)). IRDA is
> one of the last users of __attribute__((packet)). Networking code uses
> __packed now.
> 
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

Applied.
