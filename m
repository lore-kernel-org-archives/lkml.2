Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2GZVqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:46:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42497 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab2GZVqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:46:40 -0400
Message-ID: <5011BAB1.6060300@zytor.com>
Date: Thu, 26 Jul 2012 14:46:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>, Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [GIT PULL] New TPM driver and features
References: <20120726143101.GA24237@linux.vnet.ibm.com>
In-Reply-To: <20120726143101.GA24237@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 07:31 AM, Kent Yoder wrote:
>        hw_random: add support for the TPM chip as a hardware RNG source

Could you clarify this?  rngd (the user of /dev/hw_random) already has 
support for the TPM... is this fundamentally different (e.g. can it 
coexist with tcsd being in use at the same time)?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

