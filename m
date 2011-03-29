Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1C2OhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:37:10 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:37237 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1C2OhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:37:09 -0400
Message-ID: <4D91EE8D.1010305@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 11:37:01 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com, preining@logic.at
Subject: Re: [patch 2/8] tpm_tis: Re-enable interrupts upon (S3) resume
References: <20110315111307.895085413@linux.vnet.ibm.com> <20110315111425.977309317@linux.vnet.ibm.com>
In-Reply-To: <20110315111425.977309317@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11032914-9254-0000-0000-0000014157EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2011 08:13 AM, Stefan Berger wrote:
> v2:
>   - the patch was adapted to also work with a machine with a Intel iTPM
> 

This is also a separated fix, which this time I can't also identify 
in the patch, can you submit it as another patch, that applies 
on top of the original 2/8?

Rajiv

