Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0KBPf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:35:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36062 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0KBPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:35:50 -0400
Subject: Re: [PATCH] bluetooth: bnep: fix information leak to userland
From: Marcel Holtmann <marcel@holtmann.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1288448782-5582-1-git-send-email-segooon@gmail.com>
References: <1288448782-5582-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 16:35:31 +0100
Message-ID: <1288712131.3322.178.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiiy,

> Structure bnep_conninfo is copied to userland with the field "device"
> that has the last elements unitialized.  It leads to leaking of
> contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


