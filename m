Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0EOHrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 03:47:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:55154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0EOHrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 03:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DbFpZEA9V09Vu6qsr4T8YUK61XbcWVB4pCeHERgNKJXVWBuzhTh20QWaOgjK5yZ+Qg
         55G9NcCDIWfOwA/d8nvm42mqPn+bST7mFL9J5mxbUcDtHwnJSazA2KtaNEpQlcroPin9
         FG3iVj/UiDmIQ0gyHYUdJbVwmT0B2Rkh35oxg=
Message-ID: <4BEE517E.4040404@gmail.com>
Date: Sat, 15 May 2010 09:47:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, steiner@sgi.com
Subject: Re: mmotm 2010-05-14-13-33 uploaded
References: <201005142101.o4EL1Mf2022381@imap1.linux-foundation.org>
In-Reply-To: <201005142101.o4EL1Mf2022381@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 10:33 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-05-14-13-33 has been uploaded to

Hi,

with
CONFIG_CPUSETS=y
# CONFIG_NUMA is not set
I get
kernel/built-in.o: In function `copy_process':
fork.c:(.text+0xbcfa): undefined reference to `__node_random'
fork.c:(.text+0xbd0e): undefined reference to `__node_random'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

You seem to forgot to add an inline returning 0 on !NUMA in
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
?

regards,
-- 

js
