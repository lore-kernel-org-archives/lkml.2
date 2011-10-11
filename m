Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1JKKOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:14:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab1JKKN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:13:58 -0400
Message-ID: <4E9416E4.1090903@suse.cz>
Date: Tue, 11 Oct 2011 12:13:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
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
> this series teaches genksyms to ignore changes to internal files 

Er, internal _types_, sorry for the typo.

Michal
