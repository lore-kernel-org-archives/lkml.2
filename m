Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1FUUjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:39:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40158 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab1FUUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z6dAo0Q8celbO4VXm4nRYBsgGu1YSRTVsC9ItqMLCcuJCQsj2hW6qj0VSbFECswNyG
         6HNiKQXteuggzS+xVBrG+SAYmbrTSGhuf5powh6k1uQhxeuDrt25k/TwHeV8NLvQsVwo
         mnK2xPE82oatv7LQdPsR13ze5RTtkZXxFIQWw=
Message-ID: <4E010170.9050901@pobox.com>
Date: Tue, 21 Jun 2011 16:39:12 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Brian King <brking@linux.vnet.ibm.com>
CC: Nishanth Aravamudan <nacc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, wayneb@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        mbizon@freebox.fr
Subject: Re: [PATCH] libata/sas: only set FROZEN flag if new EH is supported
References: <20110615191747.GA6324@us.ibm.com> <4DF90FCA.1040706@linux.vnet.ibm.com> <20110615233417.GB6324@us.ibm.com> <20110616075114.GH8141@htj.dyndns.org> <4DFA0507.3090609@linux.vnet.ibm.com> <20110616152836.GA15268@us.ibm.com> <20110621160714.GA14174@us.ibm.com> <4E00FF58.7070802@linux.vnet.ibm.com>
In-Reply-To: <4E00FF58.7070802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 04:30 PM, Brian King wrote:
> Looks good to me. Jeff/Tejun - any issues with merging this?

Looks good here too -- though of course we want to move towards purging 
old-EH paths :)

Queued...


