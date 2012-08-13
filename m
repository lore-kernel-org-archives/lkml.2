Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2HMWAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:00:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36059 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2HMWAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:00:31 -0400
Message-ID: <502978F5.9020100@zytor.com>
Date: Mon, 13 Aug 2012 15:00:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/5] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1344894424-4434-1-git-send-email-jacob.shin@amd.com> <1344894424-4434-2-git-send-email-jacob.shin@amd.com> <20120813215829.GA25632@google.com>
In-Reply-To: <20120813215829.GA25632@google.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 02:58 PM, Tejun Heo wrote:
> 
> Also, please mention the possibility of using smaller size memory
> mappings if e820 didn't align physical memory to GB boundary.
> 

... as it generally won't.

	-hpa

