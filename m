Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2CIWNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:13:18 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45009 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab2CIWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:13:16 -0500
X-Sasl-enc: PTO/tteMCUmXnnYy5xPwglbIlrOmPI5ZfHeazacSt+Em 1331331195
Message-ID: <4F5A8079.5090800@signal11.us>
Date: Fri, 09 Mar 2012 17:13:13 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Makefile: Add INSTALL_MOD_PATH to the environment
 used by depmod
References: <1331330522-15129-1-git-send-email-alan@signal11.us>
In-Reply-To: <1331330522-15129-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 05:02 PM, Alan Ott wrote:
> Add INSTALL_MOD_PATH explicitly to the environment given to depmod.  This
> way putting an INSTALL_MOD_PATH line into a GNUmakefile (along with things
> like CROSS_COMPILE) will work properly.
>
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---

To be clear, this was intended to be patch 1/1. Sorry for the noise.
