Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2JOSzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:55:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab2JOSzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:55:06 -0400
Message-ID: <507C5C04.4040506@suse.cz>
Date: Mon, 15 Oct 2012 20:55:00 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d reverts unrelated
 changes
References: <507C475502000078000A17AA@nat28.tlf.novell.com>
In-Reply-To: <507C475502000078000A17AA@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 15.10.2012 17:26, Jan Beulich napsal(a):
> Michal,
> 
> is there any reason why that commit reverts two other changes
> (to arch/x86/Makefile and scripts/Makefile.fwinst) without any
> mention of the reason for this in the description?

Oh, I don't know how this could have happened. It seems that I did a git
commit --amend at some point :-(.

Michal

