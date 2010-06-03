Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0FCQ0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:26:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36449 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab0FCQ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:26:11 -0400
Date: Thu, 3 Jun 2010 09:24:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rabin Vincent <rabin@rab.in>
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: decodecode: use /bin/bash
Message-Id: <20100603092458.d0d603e3.randy.dunlap@oracle.com>
In-Reply-To: <1275581686-19745-1-git-send-email-rabin@rab.in>
References: <1275581686-19745-1-git-send-email-rabin@rab.in>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C07D76E.01AE:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Jun 2010 21:44:46 +0530 Rabin Vincent wrote:

> 5358db ("scripts: add ARM support to decodecode") added a few bashims to
> the decodecode script, so explicitly ask for bash.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
> Alternatively, I have a patch to remove the bashisms, if that's preferred.

Yes, that's what we usually prefer to do.
Please post it.


>  scripts/decodecode |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/decodecode b/scripts/decodecode
> index 8b30cc3..405cfac 100755
> --- a/scripts/decodecode
> +++ b/scripts/decodecode
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  # Disassemble the Code: line in Linux oopses
>  # usage: decodecode < oops.file
>  #
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
