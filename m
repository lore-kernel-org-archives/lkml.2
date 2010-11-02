Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0KBPgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:36:53 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36082 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0KBPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:36:48 -0400
Subject: Re: [PATCH] bluetooth: hidp: fix information leak to userland
From: Marcel Holtmann <marcel@holtmann.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
        Michael Poole <mdpoole@troilus.org>,
        Bastien Nocera <hadess@hadess.net>, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288448791-6009-1-git-send-email-segooon@gmail.com>
References: <1288448791-6009-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 16:36:29 +0100
Message-ID: <1288712189.3322.180.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiliy,

> Structure hidp_conninfo is copied to userland with version, product,
> vendor and name fields unitialized if both session->input and session->hid
> are NULL.  It leads to leaking of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


