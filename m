Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2CKKGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:06:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35414 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2CKKGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:06:19 -0400
Message-ID: <4F5C78C3.1070208@mvista.com>
Date: Sun, 11 Mar 2012 14:04:51 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jeff Garzik <jgarzik@pobox.com>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
References: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-03-2012 21:56, Julia Lawall wrote:

> From: Julia Lawall<Julia.Lawall@lip6.fr>

> There is no need to call the devm cleanup functions on failure of a probe
> or remove function.

    This doesn't correlate with the subject.

> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>

WBR, Sergei
