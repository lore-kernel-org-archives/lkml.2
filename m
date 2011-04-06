Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1DFVoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:44:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab1DFVoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:44:04 -0400
Message-ID: <4D9CDEA4.20102@suse.cz>
Date: Wed, 06 Apr 2011 23:44:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.2-New, apparently undfined var in include/linux/Kbuild
 breaks make headers_install
References: <201104061543.14218.gene.heskett@gmail.com>
In-Reply-To: <201104061543.14218.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.4.2011 21:43, Gene Heskett wrote:
> This is, in line 25 is $(INSTALL_HDR_PATH)
> 
> What do I export as that $VAR that will satisfy this?

It is set by the toplevel Makefile:

#Default location for installed headers
export INSTALL_HDR_PATH = $(objtree)/usr

What exactly are you doing and how does it fail?

Michal
