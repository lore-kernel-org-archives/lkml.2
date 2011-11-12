Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1KLSla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 13:41:30 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:62245 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1KLSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 13:41:28 -0500
Message-ID: <4EBECBA2.1030606@newsguy.com>
Date: Sat, 12 Nov 2011 11:40:18 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/16] mtd/docg3: fix BCH registers
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr> <1320912342-30147-5-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1320912342-30147-5-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 12:05 AM, Robert Jarzmik wrote:
> -#define DOC_BCH_SYNDROM(idx)		(0x1048 + (idx << 1))
> +#define DOC_BCH_SYNDROM(idx)		(0x1048 + (idx << 0))


Minor nit:  why the 0, and not just (0x1048 + idx) ?

Mike

