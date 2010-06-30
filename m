Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0F3Uti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:49:38 -0400
Received: from mail.vyatta.com ([76.74.103.46]:58422 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab0F3Utg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:49:36 -0400
Date: Wed, 30 Jun 2010 13:49:34 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Fulghum <paulkf@microgate.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] trivial: use ARRAY_SIZE
Message-ID: <20100630134934.74f4e269@nehalam>
In-Reply-To: <1277726089-24467-1-git-send-email-segooon@gmail.com>
References: <1277726089-24467-1-git-send-email-segooon@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 15:54:48 +0400
Kulikov Vasiliy <segooon@gmail.com> wrote:

>  	static unsigned short patterns[] =
>  		{0x0000, 0xffff, 0xaaaa, 0x5555, 0x6969, 0x9696};

Unrelated, but these patterns should be const.
