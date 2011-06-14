Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1FNNzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:55:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1FNNzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:55:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC v2 02/04] procfs: add hidepid modes as mount options
Date: Tue, 14 Jun 2011 15:54:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Rientjes <rientjes@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>
References: <1307889901-6226-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1307889901-6226-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141554.50945.arnd@arndb.de>
X-Provags-ID: V02:K0:fuUxPr4de7vI65Otfvf0MfwkS07KhC5mSgAI3fFX6Nt
 k496plSwx/kARUAblb8uUC4aHJF4Cy8NtTH6dJc6zNwWfh74yh
 wvo5NFb6OgoK/UaqqlekZ78q7ztNnM0H3PF224lTtZrNXrQV4b
 dvK52VJBipUIzGev8efkFv8OTYRjeLjQ6TqNo/o7yN9vCZ5evf
 Fg9zUeGAC2a3GnmTVYyMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 June 2011, Vasiliy Kulikov wrote:
> +static const match_table_t tokens = {
> +       {Opt_hidepid, "hidepid=%u"},
> +       {Opt_gid, "gid=%u"},
> +       {Opt_hidenet, "hidenet"},
> +       {Opt_nohidenet, "nohidenet"},
> +       {Opt_err, NULL},
> +};

I don't really have an opinion on your patch, but it seems that it does more than
the description explains: The hidenet/nohidenet option is in the patch as well,
although it doesn't have much of an effect.

	Arnd
