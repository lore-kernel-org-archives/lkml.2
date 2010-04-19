Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0DSNLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:11:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0DSNLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:11:12 -0400
Message-ID: <4BCC566F.2040004@suse.cz>
Date: Mon, 19 Apr 2010 15:11:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.7 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Module.symvers file
References: <201004181546.56064.gene.heskett@verizon.net>
In-Reply-To: <201004181546.56064.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.4.2010 21:46, Gene Heskett wrote:
> Greetings all;
> 
> I just found that a make all in 2.6.34-rc4 will generate the Module.symvers 
> file.  But my normal build and install does not.

You need to run make vmlinux and make modules (or simply make all) to
generate a full list of exported symbols. Only doing one of the steps
will generate a partial list, obviously.

Michal
