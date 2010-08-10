Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab0HJOaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:30:18 -0400
Received: from smtp-out-182.synserver.de ([212.40.180.182]:1206 "HELO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1757676Ab0HJOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:30:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 6926
Date: Tue, 10 Aug 2010 16:29:51 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, Piotr Hosowicz <piotr@hosowicz.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-acpi@vger.kernel.org
Subject: Re: BUG: scheduling while atomic: swapper/0/0x10000002
Message-ID: <20100810142951.GA7156@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100810140748.GA29878@fancy-poultry.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 04:07:48PM +0200, Heinz Diehl wrote:
> +1
> 
> [....]
> ACPI: Core revision 20100702
> BUG: scheduling while atomic: swapper/0/0x10000002
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.35-git8 #1
> Call Trace:
> [<ffffffff81441be8>] ? schedule+0x518/0x9a0
> [<ffffffff812e4262>] ? acpi_os_release_object+0x9/0xd
> [<ffffffff8103dcfd>] ? __cond_resched+0x1d/0x30
> [<ffffffff814421dd>] ? _cond_resched+0x2d/0x40
> [<ffffffff81300ca0>] ? acpi_ps_complete_op+0x24c/0x260
> [<ffffffff813014c9>] ? acpi_ps_parse_loop+0x815/0x970
> [<ffffffff813005d8>] ? acpi_ps_parse_aml+0x8f/0x2aa
> [<ffffffff812fee85>] ? acpi_ns_one_complete_parse+0xfd/0x118
> [<ffffffff812feeba>] ? acpi_ns_parse_table+0x1a/0x34
> [<ffffffff812fc685>] ? acpi_ns_load_table+0x3d/0x7c
> [<ffffffff81303321>] ? acpi_load_tables+0x9b/0x156
> [<ffffffff81798d87>] ? acpi_early_init+0x6c/0xf7
> [<ffffffff81771cf5>] ? start_kernel+0x368/0x436
> [<ffffffff81771382>] ? x86_64_start_kernel+0xe1/0xf2

This bug already has two patches available to fix it:
 
http://lkml.org/lkml/2010/8/6/672
https://patchwork.kernel.org/patch/113092/

-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
