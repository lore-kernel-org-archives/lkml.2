Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0J0XBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:01:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0J0XBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:01:39 -0400
Message-ID: <4CC8AF56.6000904@suse.cz>
Date: Thu, 28 Oct 2010 01:01:42 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] namespace: add source file location exceptions
References: <20101013155830.169ca022@nehalam>	<4CC8A836.9090402@suse.cz> <20101027154153.02b0607e@nehalam>
In-Reply-To: <20101027154153.02b0607e@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2010 00:41, Stephen Hemminger wrote:
> That patch should not be included. It causes more problems than it
> solves, since then there are duplicate file locations which causes
> false duplicate symbol reports.

Ah, ok, thanks for the info, I reverted the patch again.

Michal
