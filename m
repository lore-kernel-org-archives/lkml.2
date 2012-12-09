Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab2LIQ5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 11:57:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab2LIQ5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 11:57:18 -0500
Message-ID: <50C4C2EC.9090703@suse.cz>
Date: Sun, 09 Dec 2012 17:57:16 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/5] kbuild: remove deprecated use of defined in timeconst.pl
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
In-Reply-To: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.11.2012 21:05, pefoley2@verizon.net wrote:
> From: Peter Foley <pefoley2@verizon.net>
> 
> Fix this warning by removing a unneeded use of defined

An identical fix for this is in the -mm tree already.

Michal
