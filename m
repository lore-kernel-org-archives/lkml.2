Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937783Ab0CPK7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:59:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:55129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937772Ab0CPK7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:59:30 -0400
Message-ID: <4B9F6490.1060107@suse.cz>
Date: Tue, 16 Mar 2010 11:59:28 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, sam@ravnborg.org
Subject: Re: [PATCH v2] microblaze: Fix Makefile to delete build generated
 files
References: <1268727395-7770-1-git-send-email-arun@bhanu.net> <4B9F4988.20809@monstr.eu> <20100316105335.GA13420@icd1rh0718.eee.ntu.edu.sg>
In-Reply-To: <20100316105335.GA13420@icd1rh0718.eee.ntu.edu.sg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.3.2010 11:53, Arun Bhanu wrote:
> Adding Cc: Michal Marek <mmarek@suse.cz> who is the Kbuild maintainer.
>> I personally don't like that this line is in main arch Makefile but I  
>> saw that other archs have it too. Will be better to have it only in boot  
>> folder but I don't know if is possible to do that.
>> Sam: What do you think?
> 
> From my limited understanding of Kbuild, it only includes the top
> level Makefile of each architecture. In our case
> arch/microblaze/Makefile. If we define MRPROPER_FILES variable in
> arch/microblaze/boot/Makefile Kbuild will not evaluate it.

Correct, make mrproper is not a recursive target, so it won't read
ordinary kbuild files like arch/microblaze/boot/Makefile.

Michal
