Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab0GBNc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 09:32:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65194 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab0GBNcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 09:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nGrVzpacEutKvp+BuoRwlH7mHYoIg/1rJXYIpdMuHsPI6ONct+kRZquDOz2unLfC57
         PIcsubDW7pnYViTMhBTImVOrr2YcZ2kvmFR1EyUQzQ9g4eTTQA3SvUClWHo8yKpSamAM
         wMYGrAqmAO31Z2d6OhhwNyWFJwse/ip7m9LvA=
Message-ID: <4C2DCDE8.7050905@suse.cz>
Date: Fri, 02 Jul 2010 13:30:48 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/12] rlimits: security, add task_struct to setrlimit
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz> <alpine.LRH.2.00.1006240957350.1601@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1006240957350.1601@tundra.namei.org>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 01:58 AM, James Morris wrote:
> On Wed, 23 Jun 2010, Jiri Slaby wrote:
>> Add task_struct to task_setrlimit of security_operations to be able to set
>> rlimit of task other than current.
> 
> Given the scope of the changes, I'm not sure which tree these should go 
> into.  They affect the security API, so possibly mine.

If there are no objections, could you take it? Or maybe Andrew, if we
persuaded him?

thanks,
-- 
js
suse labs
