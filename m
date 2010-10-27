Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab0J0WbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:31:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0J0WbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:31:14 -0400
Message-ID: <4CC8A836.9090402@suse.cz>
Date: Thu, 28 Oct 2010 00:31:18 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] namespace: add source file location exceptions
References: <20101013155830.169ca022@nehalam>
In-Reply-To: <20101013155830.169ca022@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.10.2010 00:58, Stephen Hemminger wrote:
> Teach namespace checker about some special case files where the
> source is in unusual location.  This fixes many of the source file
> not found errors (more can be added), and also prevents false positives
> for functions not being used.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> ---
> Applies after previous patches by Amerigo Wang

Applied to kbuild-2.6.git#misc, sorry for the delay.

Michal
