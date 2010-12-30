Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0L3CNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 21:13:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56300 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0L3CNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 21:13:51 -0500
MIME-Version: 1.0
X-Originating-IP: [99.24.57.198]
In-Reply-To: <1293628470-28386-1-git-send-email-kas@openvz.org>
References: <1293628470-28386-1-git-send-email-kas@openvz.org>
Date: Wed, 29 Dec 2010 20:13:50 -0600
Message-ID: <AANLkTi=AXz21wDeE1vPVD-6cEtj6faXN9x09eHDCsTkB@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] make rpc_pipefs be mountable multiple time
From: Rob Landley <rob@landley.net>
To: "Kirill A. Shutemov" <kas@openvz.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, linux-nfs@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 7:14 AM, Kirill A. Shutemov <kas@openvz.org> wrote:
>
> Prepare nfs/sunrpc stack to use multiple instances of rpc_pipefs.
> Only for client for now.

What would a test case for this look like?  (Is there some way to tell
an nfs mount to use a specific instance of rpc_pipefs or something?)

Rob
