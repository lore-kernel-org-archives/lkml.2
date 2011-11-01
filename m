Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1KAX0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:26:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab1KAX0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:26:12 -0400
Message-ID: <4EB08014.8010004@suse.cz>
Date: Wed, 02 Nov 2011 00:26:12 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] genksyms: Ignore changes to internal files
References: <1318327969-24807-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1318327969-24807-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.10.2011 12:12, Michal Marek wrote:
> Hi,
> 
> this series teaches genksyms to ignore changes to internal files (those
> defined in the source file itself). See patch 2/3 for the main part.
> 
> Michal
> 
> 
> Michal Marek (3):
>   genksyms: Minor parser cleanup
>   genksyms: Do not expand internal types
>   genksyms: Regenerate lexer and parser

Looks like nobody besides me cares about genksyms :). I applied this to
my kbuild branch now.

Michal
