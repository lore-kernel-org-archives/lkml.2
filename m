Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0GMC2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:28:21 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44658 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0GMC2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:28:16 -0400
Message-ID: <4C3BCF3E.7060000@austin.ibm.com>
Date: Mon, 12 Jul 2010 21:28:14 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Bodo Eggert <7eggert@web.de>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] De-couple sysfs memory directories from memory sections
References: <f5t7d-2ZJ-23@gated-at.bofh.it> <20100712194958.1A32B2D6595@mail-in-10.arcor-online.net>
In-Reply-To: <20100712194958.1A32B2D6595@mail-in-10.arcor-online.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 02:30 PM, Bodo Eggert wrote:
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> The file 'split' allows for splitting the
>> directory in two, with each new directory covering half as many
>> memory sections as the previous directory.
> 
> Just some random thoughts:
> 1) Why is it needed/helpful?

This is needed if someone needed to perform an action (add/remove) a
single memory section. The 'split' option allows users to isolate
a memory section  so these operations could be performed.

> 2) If it is needed, why not take an int to split after n entries?

The idea of being able to split a directory came out of a previous
discussion on how to resolve the issue this patch set is trying to solve.
I included the split functionality in this patch set since it
was suggested.  I will leave the decision of whether or not this
functionality is needed up to the community.

-Nathan 
