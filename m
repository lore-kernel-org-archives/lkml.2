Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1AFPxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:53:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab1AFPxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:53:18 -0500
Message-ID: <4D25E566.6050904@suse.cz>
Date: Thu, 06 Jan 2011 16:53:10 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bug in scripts/package/mkspec?
References: <AANLkTin01j5oTUdh6fAgs--Gi46BZOWZCdypUPd8uhm4@mail.gmail.com>	<4CF7BA6D.60002@suse.cz>	<AANLkTinK9dKnSZdkH57dZNMysg0uVu7DfNtmmZdG8HZD@mail.gmail.com>	<20110106125412.GB1841@sepie.suse.cz> <AANLkTinq_1Uq6f--YzR87j-pBVWW0U-1RQS4-KoEQmXn@mail.gmail.com>
In-Reply-To: <AANLkTinq_1Uq6f--YzR87j-pBVWW0U-1RQS4-KoEQmXn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.1.2011 15:28, Patrick LeBoutillier wrote:
> Michal,
> 
> Maybe the easiest way is just to rebuild the spec file everytime we do
> "make rpm".
> I'll try it and see how it does.
> 
> Do you know of the .version file is used for anything outside of the
> "make rpm" process?

It is used to build the UTS_VERSION string, aka uname -v. It's the
number after the hash sign.

Michal
