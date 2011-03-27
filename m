Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1C0NQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 09:16:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:54949 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab1C0NQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 09:16:13 -0400
Message-ID: <4D8F3895.1050909@suse.cz>
Date: Sun, 27 Mar 2011 15:16:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Module.symvers not ignored at all?
References: <AANLkTinMY7BhPL_WAjnZr-zBOEQTbABvCVBmg1AowtON@mail.gmail.com>
In-Reply-To: <AANLkTinMY7BhPL_WAjnZr-zBOEQTbABvCVBmg1AowtON@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.3.2011 17:59, Ralf Thielow wrote:
> Hello,
> 
> why is "Module.symvers" only ignored in the root directory
> but not in the others? If i rebuild separate modules, i see some
> of these files with "git status".

If you do it the documented way, i.e. make path/to/module.ko instead of
abusing M=, then no Module.symvers in the subdirectory will be created.

Michal
