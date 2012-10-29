Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab2J2SN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:13:29 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33706 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab2J2SN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:13:27 -0400
Subject: Re: [Pv-drivers] [PATCH] vmxnet3: must split too big fragments
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bhavesh Davda <bhavesh@vmware.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jongman heo <jongman.heo@samsung.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <1948210032.25549736.1351533171670.JavaMail.root@vmware.com>
References: <1948210032.25549736.1351533171670.JavaMail.root@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 19:13:21 +0100
Message-ID: <1351534401.12280.132.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 10:52 -0700, Bhavesh Davda wrote:
> LGTM. Thanks for doing this! Did you do any performance testing with this patch?
> 
> Reviewed-by: Bhavesh Davda <bhavesh@vmware.com>

Just to be clear : I coded the patch and compiled it, but didnt test it.

Jongman did the tests ;)

Thanks !


