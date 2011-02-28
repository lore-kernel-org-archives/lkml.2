Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1B1Jbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:31:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1B1Jbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:31:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: james_p_freyensee@linux.intel.com
Subject: Re: [PATCH 04/10] PTI Makefile and Kconfig additions.
Date: Mon, 28 Feb 2011 10:31:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
References: <james_p_freyensee@linux.intel.com> <1298570824-26085-5-git-send-email-james_p_freyensee@linux.intel.com>
In-Reply-To: <1298570824-26085-5-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281031.42402.arnd@arndb.de>
X-Provags-ID: V02:K0:pSnAWk0XZEMBWASicPHw6QRchPCmyvblLlcAcALL/yO
 /SGnTIu8N0pFsgsIG0hVhv90jAlQyWWs8Z9SeCA3CLfhhj5LP6
 xONBBxIyg6t676UEeGTuZwQ8D3gLBhjF9vE7cKCHCUsk5uE+u+
 wu75wVphLSCi/xVJAq0/OkxIfOgCtuuzvfG/Ukq87g5LftClpU
 tPHgFGctm2CO3Jw8TVU4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 February 2011, james_p_freyensee@linux.intel.com wrote:
> 
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This allows the Intel implementation of the PTI standard to be
> compiled and configured in Kconfig.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>

This belongs together with the pti.c file, just merge the patches
into one.

The Kconfig description is a nice text, how about copying it to the
changeset so that reviewers know what the driver is about?

	Arnd
