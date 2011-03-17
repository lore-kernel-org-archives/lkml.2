Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1CQOSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:18:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab1CQOSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:18:21 -0400
Message-ID: <4D82182B.5020202@suse.cz>
Date: Thu, 17 Mar 2011 15:18:19 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] genksyms: Track changes to enum constant
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz> <20110313071902.GA3377@merkur.ravnborg.org> <4D7CC931.1090204@suse.cz>
In-Reply-To: <4D7CC931.1090204@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.3.2011 14:40, Michal Marek wrote:
>> This nice explanation would be good to include in the changelog
>> of 7/8 so "git log" give a better intro to the changes.
> 
> Good idea, I'll update the patch description.

I updated the patch description and merged this into kbuild-2.6.git#kbuild.

Michal
