Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0HaOIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:08:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:55177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab0HaOIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:08:31 -0400
Message-ID: <4C7D0CDB.6030903@suse.cz>
Date: Tue, 31 Aug 2010 16:08:27 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 0/2] initramfs: Cleanup and fix initramfs size calculation
References: <20100831082307.064687027@linux.vnet.ibm.com>
In-Reply-To: <20100831082307.064687027@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.8.2010 10:23, Hendrik Brueckner wrote:
> Hello Michal, Sam,
> 
> I did not see any further comments on the patch series about the
> initramfs cleanup and new size calculation.

Sorry about that, I don't always have as much time for kbuild as I would
like to have :(.


> This is a resend and now I am asking you for your review and ack.
> Please let me know if you have questions or comments.

I like the cleanup patch and the thing still survives (very basic)
testing, so
Acked-by: Michal Marek <mmarek@suse.cz>

I'm wondering which tree should these patches go through... Peter, will
you apply them to some branch of tip.git or should I apply them to
kbuild-2.6.git?

Michal
