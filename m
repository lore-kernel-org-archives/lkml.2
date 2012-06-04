Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2FDDbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:31:14 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:48467 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755767Ab2FDDbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:31:11 -0400
Message-ID: <4FCC2BF9.7000802@xenotime.net>
Date: Sun, 03 Jun 2012 20:31:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: Tree for Jun 1 (scsi)
References: <20120601132202.ac73b03c845299d384defeaf@canb.auug.org.au>
In-Reply-To: <20120601132202.ac73b03c845299d384defeaf@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 08:22 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120531:



already fixed?

on i386 and x86_64, loadable module or builtin:


ERROR: "scsi_sd_probe_domain" [drivers/scsi/scsi_mod.ko] undefined!
or
(.text+0x4f6c77): undefined reference to `scsi_sd_probe_domain'

-- 

~Randy
(sorry about the delay, was out for 3 days)
