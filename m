Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1L3KaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 05:30:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1L3KaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 05:30:08 -0500
Message-ID: <4EFD92AF.7000402@suse.cz>
Date: Fri, 30 Dec 2011 11:30:07 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: add target to install gzipped modules
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi> <4EFC9872.7000708@suse.cz> <CAMOw1v6GhA+B2oXcVK4YZULb6kq=-NFTv-=-4eYB0ukZ9acP-w@mail.gmail.com>
In-Reply-To: <CAMOw1v6GhA+B2oXcVK4YZULb6kq=-NFTv-=-4eYB0ukZ9acP-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.12.2011 18:35, Lucas De Marchi wrote:
> The operation that is used most of the time is to load modules. The
> reason for having modules gzipped is the same one as for kernel image:

The reason for having the kernel compressed is that the x86 bootloader
reads the kernel (and initrd) using bios calls. That's not the case for
modules.

Michal
